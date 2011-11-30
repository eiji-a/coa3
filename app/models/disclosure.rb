# -*- coding: utf-8 -*-
class Disclosure < ActiveRecord::Base

  # RELATIONSHIP
  has_many :contents
  has_many :folders
  has_many :tags
  belongs_to :user
  has_many :grants

  # CONSTANTS

  # METHODS

  def self.list(user_id)
    Disclosure.find(:all,
                    :conditions => ['user_id = ?', user_id],
                    :order => :name).map do |d|
      [d.name, d.id]
    end
  end

  def grant(user_id, priv)
    grants.each do |g|
      return nil if g.user.id == user_id
    end
    g = Grant.new({:user_id => user_id, :privilege => priv})
    grants << g
    g.save
  end
  
  def able?(user_id, priv)
    privilege(user_id) >= priv
  end

  def browsable?(user_id)
    able?(user_id, Grant::BROWSABLE)
  end

  def linkable?(user_id)
    able?(user_id, Grant::LINKABLE)
  end

  def editable?(user_id)
    able?(user_id, Grant::EDITABLE)
  end

  def sharable?(user_id)
    able?(user_id, Grant::SHARABLE)
  end

  def owner?(user_id)
    able?(user_id, Grant::OWNERSHIP)
  end

  def privilege(user_id)
    @privileges = {} if @privileges == nil
    if @privileges[user_id] == nil
      @privileges[user_id] = Grant::UNABLE
      grants.each do |g|
        next if g.user.id != user_id
        @privileges[user_id] = g.privilege
        break
      end
    end
    @privileges[user_id]
  end
end

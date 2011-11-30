# -*- coding: utf-8 -*-
class Tag < ActiveRecord::Base

  # RELATIONSHIP
  belongs_to :user
  belongs_to :disclosure
  has_and_belongs_to_many :contents

  # METHODS

  def self.create(name, user_id)
    t = Tag.new
    t.name = name
    t.user_id = user_id
    t.order = 0
    t.save
    t
  end

  def self.list(user_id)
    Tag.find(:all, :conditions => ['user_id = ?', user_id]).map do |t|
      [t.name, t.id]
    end
  end

  def self.get(name, user_id)
    tag = Tag.find(:all, :conditions => ['user_id = ? AND name LIKE ?',
                                         user_id, '%' + name + '%'])
    return nil if tag == []
    tag.each do |t|
      t.name.split(/\s+/).each do |n|
        return t if n == name
      end
    end
    nil
  end

  def first_name
    name.split(/[\s+|　]/)[0]
  end

end

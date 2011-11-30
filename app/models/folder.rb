# -*- coding: utf-8 -*-
class Folder < ActiveRecord::Base

  # RELATIONSHIPS
  belongs_to :user
  belongs_to :disclosure
  has_many :contents, :order => 'created_at ASC'

  # VALIDATES
  validates_presence_of :name, :user_id
  validates_numericality_of :list_flag
  validate :valid_list_number, :uniqueness_name_each_user

  # CONSTANTS
  DISPLAY = 0
  HIDDEN  = 1
  LISTING = ['表示', '非表示']

  # METHODS
  def self.listing
    [[LISTING[DISPLAY], DISPLAY], [LISTING[HIDDEN], HIDDEN]]
  end

  def self.list(user_id)
    Folder.find(:all, :conditions => ['user_id = ?', user_id]).map {|f|
      [f.name, f.id]
    }
  end

  def browsable?(user_id)
    disclosure.browsable?(user_id)
  end

  def linkable?(user_id)
    disclosure.linkable?(user_id)
  end

  def editable?(user_id)
    disclosure.editable?(user_id)
  end

  def sharable?(user_id)
    disclosure.editable?(user_id)
  end

  def owner?(user_id)
    disclosure.owner?(user_id)
  end

  private

  def uniqueness_name_each_user
    return if id != nil
    folder = Folder.find_by_name_and_user_id(name, user_id)
    errors.add(:name, "既に同名のフォルダが登録されています") if !folder.nil?
  end

  def valid_list_number
    errors.add(:list_flag, "は正しいフラグ値ではありません") if (list_flag.nil? || LISTING[list_flag] == nil)
  end

end

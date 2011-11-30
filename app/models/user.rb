# -*- coding: utf-8 -*-

require 'digest/sha1'

class User < ActiveRecord::Base

  attr_accessor :password_confirmation

  # RELATIONSHIPS
  has_many :folders, :order => "sequence, name DESC"
  has_many :contents
  has_many :grants

  # VALIDATES
  validates_presence_of :userid
  validates_presence_of :name
  validates_presence_of :priv
  validates_uniqueness_of :userid
  validates_confirmation_of :password
  validate :password_non_blank

  # CONSTANTS
  ADMIN = 0
  USER  = 1
  PRIV = ['管理者', '利用者']
  WORD = 'potter'

  # METHODS

  def self.authenticate(userid, password)
    user = self.find_by_userid(userid)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end

  def self.privs()
    [['管理者', ADMIN], ['利用者', USER]]
  end

  def self.everyone
    return @@everyone if @@everyone
    @@everyone = User.find_by_userid(:first, Const.get('everyone_user'))
  end

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end


  private

  def password_non_blank
    errors.add(:password, 'パスワードを入力してください') if hashed_password.blank?
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + WORD + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

end

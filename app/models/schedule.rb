# -*- coding: utf-8 -*-
class Schedule < ActiveRecord::Base

  # RELATIONSHIP
  belongs_to :content

  # VALIDATES
  validates_presence_of :subject, :start_date
  validate :valid_datetime_valance, :valid_datetime

  # CONSTANTS
  PLAN = 1
  RECORD = 2

  # METHODS


  private

  def valid_datetime_valance
    errors.add(:start_time, "は終了時刻がある場合は省略できません") if start_time == '' && end_time != ''
    errors.add(:end_date, "は開始日より過去を設定できません") if end_date != nil && start_date > end_date
    errors.add(:end_time, "は開始日時より過去を設定できません") if start_date == end_date && end_time != '' && start_time > end_time
  end

  def valid_datetime
    errors.add(:start_time, "は正しい時刻ではありません #{start_time}") unless valid_time?(start_time)
    errors.add(:end_time, "は正しい時刻ではありません #{end_time}") unless valid_time?(end_time)
  end

  def valid_date?(date)
    return true if date == nil
  end

  def valid_time?(time)
    return true if time == nil || time == ''
    return false if time !~ /^(\d\d)(\d\d)$/
    hour = $1.to_i
    mini = $2.to_i
    return false if hour < 0 || hour >= 24
    return false if mini < 0 || mini >= 60
    true
  end
end

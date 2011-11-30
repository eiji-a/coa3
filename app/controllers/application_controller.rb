# -*- coding: utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout 'coa'
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  before_filter :common, :make_menu

  def common
    date = Date.today
    @_year = date.year
    @_month = date.month
    @_day = date.day
    @_wday = Calendar::WDAY[date.wday]

    sche = Schedule.find(:all, :conditions => ['start_date = ?', date],
                         :order => "start_time ASC")
    @count = 
    @_day = Day.new(date)
    sche.each do |s|
      next if s.content.browsable?(session[:user_id]) == false
      @_day.add_schedule(s)
    end
  end

  def make_menu
    if session[:user_id] == nil
      @menu = []
      return
    end
    @login = User.find(session[:user_id])
    if @login.priv == User::ADMIN
      @admin = [['ユーザ管理', 'users', 'index']]
    end

    # GTDプロジェクトリスト取得
    @gtdprojects = GtdProject.list(@login.id)

    # フォルダリスト取得
    #@folders = Folder.find(:all,
    #                       :conditions => ["user_id = ? AND list_flag = ?",
    #                                       session[:user_id], 0],
    #                       :order => 'name')
    @folders_m = []
    Folder.find(:all, :order => 'user_id, sequence, name').each do |f|
      if f.disclosure == nil
        @folders_m << f if f.user_id == @login.id
      else
        next if f.disclosure.privilege(@login.id) < Grant::BROWSABLE
        @folders_m << f
      end
    end
    @tags = Tag.find(:all,
                     :conditions => ['user_id = ?', @login.id],
                     :order => 'name')
    
    if session[:folder_id] != nil
      @folder = Folder.find(session[:folder_id])
    end
  end
end

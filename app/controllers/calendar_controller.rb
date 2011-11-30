# -*- coding: utf-8 -*-
class CalendarController < ApplicationController

  WEEK_E = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
  WEEK_J = ['日', '月', '火', '水', '木', '金', '土']

  # day
  def day
    # スケジュール作成のための準備
    session[:content_id] = nil
    session[:date] = params[:id]

    # 当日に関連するスケジュール、コンテンツの取得
    params[:id] =~ /^(\d\d\d\d)(\d\d)(\d\d)$/
    date = Date.new($1.to_i, $2.to_i, $3.to_i)
    @pdate = date - 1
    @ndate = date + 1
    @day = Day.new(date)
    sche = Schedule.find(:all,
                         :conditions => ['start_date = ?', date],
                         :order => 'start_time ASC')
    sche.each do |s|
      @day.add_schedule(s) if s.content.disclosure.browsable?(@login.id)
    end

    @ext = if @day.holiday.size > 0 || @day.wday == 0 then
             '_holi'
           elsif @day.wday == 6 then
             '_sat'
           else
             ''
           end

    @contents = Content.find(:all,
                             :conditions => ['date(created_at) = ? AND user_id = ? AND folder_id IS NOT NULL', date, session[:user_id]],
                             :order => 'title ASC')

    @title = "カレンダー: #{date.strftime("%Y/%m/%d")}"
    respond_to do |format|
      format.html
      format.xml { render :xml => @day }
    end
  end

  # month
  def month
    # 月カレンダー
    session[:month] = params[:id]
    
    # 表示範囲の計算
    @year, @month = get_year_month(params[:id])
    sd = Date.new(@year, @month, 1)
    ed = sd.end_of_month
    @sdate = sd - (sd.cwday % 7)
    @edate = ed + ((6 - ed.cwday) % 7)
    @prevm = (sd - 1).strftime("%Y%m")
    @nextm = (ed + 1).strftime("%Y%m")

    @days = get_days(@sdate, @edate)
    @month_name = Calendar::MONTH_NAME_J[@month - 1] + '<br />' +
      Calendar::MONTH_NAME_E[@month - 1]
    @title = "カレンダー: #{@year}/#{@month}"

    respond_to do |format|
      format.html
      format.xml { render :xml => @month }
    end
  end

  # 月：リスト表示型
  def lmonth
    session[:month] = params[:id]
    @year, @month = get_year_month(params[:id])
    @sdate = Date.new(@year, @month, 1)
    @edate = @sdate.end_of_month
    @prevm = (@sdate - 1).strftime("%Y%m")
    @nextm = (@edate + 1).strftime("%Y%m")
    @days = get_days(@sdate, @edate)
    @month_name = Calendar::MONTH_NAME_J[@month - 1] + '<br />' +
      Calendar::MONTH_NAME_E[@month - 1]
    @title = "カレンダー: #{@year}/#{@month}"
=begin
    respond_to do |format|
      format.html
      format.xml { render :xml => @month }
    end
=end
  end

  # 年
  def year

  end

  :private

  def get_year_month(id)
    id =~ /^(\d\d\d\d)(\d\d)$/
    return $1.to_i, $2.to_i
  end

  def get_days(start_day, end_day)
    sche = Schedule.find(:all,
       :conditions => ["start_date >= ? and start_date <= ?",
                       start_day, end_day],
       :order => "start_date ASC, start_time ASC")
 
    days = []
    (end_day - start_day + 1).to_i.times do |i|
      days[i] = Day.new(start_day + i)
    end
    sche.each do |s|
      days[s.start_date - start_day].add_schedule(s) if s.content.disclosure.browsable?(@login.id)
    end
    days
  end
end


# -*- coding: utf-8 -*-
class SchedulesController < ApplicationController
  # GET /schedules
  # GET /schedules.xml
  def index
    @schedules = Schedule.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schedules }
    end
  end

  # GET /schedules/1
  # GET /schedules/1.xml
  def show
    @schedule = Schedule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @schedule }
    end
  end

  # GET /schedules/new
  # GET /schedules/new.xml
  def new
    @schedule = Schedule.new
    @content = Content.find(session[:content_id]) if session[:content_id]
    if @content != nil
      @schedule.content = @content
      @schedule.subject = @content.title
    end
    
    if params[:date] != nil
      @today = params[:date]
    else
      @today = Time.now.strftime("%Y%m%d")
    end
    #@schedule.start_date = Time.now
    #@schedule.end_date = Time.now

    @title = 'スケジュール作成'
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @schedule }
    end
  end

  # GET /schedules/1/edit
  def edit
    @schedule = Schedule.find(params[:id])

    @title = 'スケジュール更新'

  end

  # POST /schedules
  # POST /schedules.xml
  def create
    # 終了日を省略した場合は開始日と同日とする
    # ただし終了時刻も入力ない場合は開始日時しか必要ないと解釈する
    if params[:schedule][:end_date] == '' &&
       params[:schedule][:end_time] != ''
      params[:schedule][:end_date] = params[:schedule][:start_date]
    end
    @schedule = Schedule.new(params[:schedule])
    if params[:schedule][:content_id] == ''
      content = Content.create_min(@schedule.subject, params[:detail],
                                   session[:user_id], params[:disclosure][:id])
      @schedule.content = content
      # 件名で検索できるように登録
      Searcher.open(Const.get('searcher_db')) do |db|
        stat = db.regist(content)
      end
    end
    
    respond_to do |format|
      if @schedule.save
        flash[:notice] = '' if flash[:notice] == nil
        flash[:notice] = flash[:notice] + "スケジュール'#{@schedule.subject}'が追加されました"
        if params[:schedule][:content_id] == ''
          format.html { redirect_to(:controller => 'calendar', :action => 'day', :id => @schedule.start_date.strftime("%Y%m%d")) }
        else
          format.html { redirect_to(@schedule.content) }
        end
        format.xml  { render :xml => @schedule, :status => :created, :location => @schedule }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @schedule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /schedules/1
  # PUT /schedules/1.xml
  def update
    @schedule = Schedule.find(params[:id])

    respond_to do |format|
      if @schedule.update_attributes(params[:schedule])
        flash[:notice] = 'Schedule was successfully updated.'
        format.html { redirect_to(@schedule.content) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @schedule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.xml
  def destroy
    @schedule = Schedule.find(params[:id])
    @schedule.destroy
    @content = @schedule.content

    respond_to do |format|
      format.html { redirect_to(@content) }
      format.xml  { head :ok }
    end
  end
end

# -*- coding: utf-8 -*-
class DisclosuresController < ApplicationController
  # GET /disclosures
  # GET /disclosures.xml
  def index
    @disclosures = Disclosure.find(:all,
                                   :conditions => ["user_id = ?", session[:user_id]],
                                   :order => 'name')
    @title = '公開設定管理'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @disclosures }
    end
  end

  # GET /disclosures/1
  # GET /disclosures/1.xml
  def show
    @disclosure = Disclosure.find(params[:id])
    @users = User.all
    @title = '公開設定: ' + @disclosure.name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @disclosure }
    end
  end

  # GET /disclosures/new
  # GET /disclosures/new.xml
  def new
    @disclosure = Disclosure.new
    @title = '公開設定作成'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @disclosure }
    end
  end

  # GET /disclosures/1/edit
  def edit
    @disclosure = Disclosure.find(params[:id])
    @title = '公開設定更新: ' + @disclosure.name
  end

  # POST /disclosures
  # POST /disclosures.xml
  def create
    @disclosure = Disclosure.new(params[:disclosure])

    respond_to do |format|
      if @disclosure.save
        flash[:notice] = "公開設定 '#{@disclosure.name}' が作成されました。"
        format.html { redirect_to(:action => 'index') }
        format.xml  { render :xml => @disclosure, :status => :created, :location => @disclosure }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @disclosure.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /disclosures/1
  # PUT /disclosures/1.xml
  def update
    @disclosure = Disclosure.find(params[:id])

    respond_to do |format|
      if @disclosure.update_attributes(params[:disclosure])
        flash[:notice] = "公開設定 '#{@disclosure.name}' が更新されました。"
        format.html { redirect_to(@disclosure) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @disclosure.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /disclosures/1
  # DELETE /disclosures/1.xml
  def destroy
    @disclosure = Disclosure.find(params[:id])
    @disclosure.destroy

    respond_to do |format|
      format.html { redirect_to(disclosures_url) }
      format.xml  { head :ok }
    end
  end

  # 権限付与
  def grant
    @disclosure = Disclosure.find(params[:disclosure_id])
    @user = User.find(params[:user][:id])
    @grant = Grant.new
    @grant.privilege = params[:privilege][:code]
    @grant.user = @user
    @grant.disclosure = @disclosure
    respond_to do |format|
      if @grant.save == false
        flash[:error] = "権限付与に失敗しました"
      end
      format.html { redirect_to(:action => 'show', :id => @disclosure) }
      format.html { head :ok }
    end
  end

  def strip
    grant = Grant.find(params[:grant_id])
    grant.destroy
    respond_to do |format|
      if grant.save == false
        flash[:error] = "権限を外しました"
      end
      format.html { redirect_to(:action => 'show', :id => params[:id]) }
      format.html { head :ok }
    end

  end
end

# -*- coding: utf-8 -*-
class FoldersController < ApplicationController
  # GET /folders
  # GET /folders.xml
  def index
    session[:folder_id] = nil
    #login = User.find(session[:user_id])
    #@folders = login.folders
    @folders = []
    Folder.find(:all, :order => 'user_id, sequence, name').each do |f|
      if f.disclosure == nil
        @folders << f if f.user_id == session[:user_id]
      else
        next if f.disclosure.privilege(session[:user_id]) < Grant::BROWSABLE
        @folders << f
      end
    end
    @title = 'フォルダ管理'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @folders }
    end
  end

  # GET /folders/1
  # GET /folders/1.xml
  def show
    user = User.find(session[:user_id])
    @folders = user.folders
    @folder = Folder.find(params[:id])
    @priv = @folder.disclosure.privilege(session[:user_id])
    session[:folder_id] = @folder.id
    #@contents = @folder.contents
    @contents = @folder.contents.all(:order => 'title ASC')
    @title = 'フォルダ: ' + @folder.name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @folder }
    end
  end

  # GET /folders/new
  # GET /folders/new.xml
  def new
    @folder = Folder.new
    @title = 'フォルダ作成'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @folder }
    end
  end

  # GET /folders/1/edit
  def edit
    @folder = Folder.find(params[:id])
    session[:folder_id] = @folder.id
  end

  # POST /folders
  # POST /folders.xml
  def create
    @folder = Folder.new(params[:folder])

    respond_to do |format|
      if @folder.save
        flash[:notice] = "フォルダ [#{@folder.name}] が作成されました"
        format.html { redirect_to(:action => 'index') }
        format.xml  { render :xml => @folder, :status => :created, :location => @folder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /folders/1
  # PUT /folders/1.xml
  def update
    @folder = Folder.find(params[:id])

    respond_to do |format|
      if @folder.update_attributes(params[:folder])
        flash[:notice] = "フォルダ [#{@folder.name}] が更新されました"
        format.html { redirect_to(:action => 'index') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @folder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.xml
  def destroy
    @folder = Folder.find(params[:id])
    @folder.destroy
    session[:folder_id] = nil

    respond_to do |format|
      format.html { redirect_to(folders_url) }
      format.xml  { head :ok }
    end
  end

  def move
    #flash[:notice] = "folder_id=#{params[:folder][:id]}"
    flash[:notice] = "selectitem=#{params['select'].keys.join(',')}"
    folder = Folder.find(params[:folder][:id])
    if folder != nil
      cons = Content.find(params['select'].keys,
                          :conditions => ['user_id = ?', session[:user_id]])
      cons.each do |c|
        c.folder = folder
        c.save
      end
    end

    respond_to do |format|
      format.html { redirect_to(:action => 'show', :id => session[:folder_id]) }
      format.xml { head :ok }
    end
  end
end

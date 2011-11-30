# -*- coding: utf-8 -*-
class TagsController < ApplicationController
  # GET /tags
  # GET /tags.xml
  def index
    @tags = Tag.find(:all, :conditions => ['user_id = ?', session[:user_id]],
                     :order => 'name')

    @title = 'タグ一覧'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.xml
  def show
    @tag = Tag.find(params[:id])

    @title = "タグ: #{@tag.first_name}"

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # GET /tags/new
  # GET /tags/new.xml
  def new
    @tag = Tag.new
    @title = 'タグ作成'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
    @title = "タグ編集: #{@tag.name}"
  end

  # POST /tags
  # POST /tags.xml
  def create
    @tag = Tag.new(params[:tag])
    @tag.disclosure_id = nil if @tag.disclosure_id == -1

    respond_to do |format|
      if @tag.save
        flash[:notice] = 'Tag was successfully created.'
        format.html { redirect_to(@tag) }
        format.xml  { render :xml => @tag, :status => :created, :location => @tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.xml
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      @tag.name = params[:tag][:name].gsub("　", ' ')
      @tag.disclosure = nil if @tag.disclosure_id == -1
      if @tag.save
        flash[:notice] = "タグ '#{@tag.first_name}' が更新されました。"
        format.html { redirect_to(@tag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.xml
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to(tags_url) }
      format.xml  { head :ok }
    end
  end

  # unlink
  def unlink
    @tag = Tag.find(params[:id])
    content = Content.find(params[:content_id])
    @tag.contents.delete content

    respond_to do |format|
      format.html { redirect_to(:action => 'show', :id => @tag.id) }
      format.xml { head :ok }
    end
  end
end

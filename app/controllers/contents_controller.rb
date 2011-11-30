# -*- coding: utf-8 -*-
class ContentsController < ApplicationController
  # GET /contents
  # GET /contents.xml
  def index
    @contents = Content.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contents }
    end
  end

  # GET /contents/1
  # GET /contents/1.xml
  def show
    @content = Content.find(params[:id])
    @folder = Folder.find(@content.folder_id) if @content.folder_id != nil
    @content.accessed_at = Time.now
    @content.save
    session[:content_id] = @content.id if @content != nil
    case @content.mime_type
    when 'text'
      @type1 = 'text'
    when 'image'
      @type1 = 'image'
    when 'application'
      @type1 = 'app'
      @type1 = 'pdf' if @content.mime_subtype == 'pdf'
      @type1 = 'text' if @content.mime_subtype =~ /^x-coa3-/
    else
      @type1 = 'other'
    end
    @priv = @content.privilege(session[:user_id])

    @title = @content.title

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @content }
    end
  end

  # GET /contents/new
  # GET /contents/new.xml
  def new
    @parent = if params[:parent_id] then
                Content.find(params[:parent_id])
              else
                nil
              end

    if @parent != nil && session[:child_id]
      respond_to do |format|
        format.html { redirect_to(:action => 'link', :id => @parent) }
        format.xml { render :xml => @content }
      end
      return
    end

    @content = Content.new
    #@content.folder_id = session[:folder_id]
    @content.disclosure_id = @parent.disclosure_id if @parent != nil
    @title = 'コンテンツ作成'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @content }
    end
  end

  # GET /contents/1/edit
  def edit
    @content = Content.find(params[:id])
    @folder = @content.folder
    @title = "コンテンツ編集: #{@content.title}"
  end

  # POST /contents
  # POST /contents.xml
  def create
    @content = Content.new(params[:content])

    respond_to do |format|
      if @content.save
        Searcher.open(Const.get('searcher_db')) do |db|
          db.regist(@content)
        end
        flash[:notice] = "'#{@content.title}'が作成されました。: #{@content.path}"
        
        @parent = Content.find(params[:parent_id]) if params[:parent_id]
        if @parent != nil
          @parent.children << @content
          format.html { redirect_to(@parent) }
        else
          fid = session[:folder_id]
          fid = params[:content][:folder_id] if fid == nil
          @folder = Folder.find(fid)
          format.html { redirect_to(@folder) }
        end
        format.xml  { render :xml => @content, :status => :created, :location => @content }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @content.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contents/1
  # PUT /contents/1.xml
  def update
    @content = Content.find(params[:id])
    @folder = Folder.find(session[:folder_id])

    respond_to do |format|
      if @content.update_attributes(params[:content])
        Searcher.open(Const.get('searcher_db')) do |db|
          db.erase(@content)
          db.regist(@content)
        end
        flash[:notice] = "'#{@content.title}'が更新されました。"
        format.html { redirect_to(@content) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @content.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.xml
  def destroy
    @content = Content.find(params[:id])
    @folder = Folder.find(session[:folder_id])
    Searcher.open(Const.get('searcher_db')) do |db|
      db.erase(@content)
    end
    @content.destroy

    respond_to do |format|
      #format.html { redirect_to(contents_url) }
      format.html { redirect_to(@folder) }
      format.xml  { head :ok }
    end
  end

  # GET /contents/output/1
  def output
    @content = Content.find(params[:id])
    if @content.disclosure.privilege(session[:user_id]) < Grant::BROWSABLE
      flash[:error] = "'#{@content.title}'を見る権限がありません。"
      redirect_to(:controller => 'content', :action => 'index')
    else
      send_file(@content.filepath,
                :filename => @content.path,
                :type => @content.mimetype,
                :disposition => 'inline');
    end
  end

  # POST /contents/search
  def search
    Searcher.open(Const.get('searcher_db')) do |db|
      @list = db.search(params[:search][:condition])
    end
    begin
      @contents = Content.find(@list.keys,
                               :conditions => ['user_id = ?', session[:user_id]])
    rescue
      @contents = []
    end

    @title = '検索結果'

    respond_to do |format|
      format.html { render('index') }
      format.xml  { render :xml => @contents }
    end
  end

  # GET /contents/select_folder/id
  def select_folder
    @content = Content.find(params[:id])
    login = User.find(session[:user_id])
    @folders = login.folders
    @title = "フォルダ移動: #{@content.title}"

    respond_to do |format|
      format.html
      format.xml { render :xml => @folders }
    end
  end

  # 
  def change_folder
    @content = Content.find(params[:id])
    @folder = Folder.find(params[:folder_id])
    
    if @folder != nil && @content != nil
      @content.folder = @folder
      @content.save
    end

    respond_to do |format|
      format.html { redirect_to(@content) }
      format.xml { render :xml => @content }
    end
  end

  #
  def refer
    con = Content.find(params[:id])
    session[:child_id] = con.id
    flash[:notice] = "コンテンツ'#{con.title}'からの参照先を選んでください。"

    respond_to do |format|
      format.html { redirect_to(:controller => 'folders') }
      format.xml { render :xml => con }
    end
  end

  #
  def link
    if session[:child_id] == nil
      respond_to do |format|
        format.html { redirect_to(:action => 'new') }
        format.xml { render :xml => con }
      end
      return
    end

    @content = Content.find(params[:id])
    @child = Content.find(session[:child_id]) if session[:child_id]

    respond_to do |format|
      format.html
      format.xml { render :xml => con }
    end
  end

  def create_link
    @parent = Content.find(params[:parent_id])
    @child  = Content.find(params[:child_id])
    if check_priv(@parent) && check_priv(@child)
      @parent.children << @child
      session[:child_id] = nil
      flash[:notice] = "コンテンツ'#{@child.title}'からコンテンツ" +
        "'#{@parent.title}'への参照を作成しました。"
    else
      flash[:notice] = "親もしくは子コンテンツが存在しないか権限がありません。" +
        "親:#{@parent}, 子:#{@child}"
    end

    respond_to do |format|
      format.html { redirect_to(:action => 'show', :id => @parent) }
      format.xml { render :xml => con }
    end
  end

  def undo_refer
    session[:child_id] = nil
    respond_to do |format|
      format.html { redirect_to(:action => 'new', :parent_id => params[:id]) }
      format.xml { render :xml => con }
    end
  end

  def unlink
    @parent = Content.find(params[:parent_id])
    @child  = Content.find(params[:child_id])
    if check_priv(@parent) && check_priv(@child)
      @parent.children.delete(@child)
      flash[:notice] = "コンテンツ'#{@child.title}'からコンテンツ" +
        "'#{@parent.title}'への参照を削除しました。"
    else
      flash[:notice] = "親もしくは子コンテンツが存在しないか権限がありません。" +
        "親:#{@parent}, 子:#{@child}"
    end

    respond_to do |format|
      format.html { redirect_to(:action => 'show', :id => params[:id]) }
      format.xml { render :xml => con }
    end
  end

  def tag
    @content = Content.find(params[:id])
    tags = @content.tags
    @tagnames = tags.map {|t| t.first_name}
    @title = "タグ更新: #{@content.title}"
  end

  def update_tag
    content = Content.find(params[:id])
    content.tags.delete_all
    params[:tags].split(/\s+|　/).each do |t|
      tag = Tag.get(t, session[:user_id])
      if tag == nil
        flash[:notice] = "" if flash[:notice] == nil
        flash[:notice] += "タグ'#{t}'は新規。"
        tag = Tag.create(t, session[:user_id])
      end
      content.tags << tag
    end
    
    respond_to do |format|
      format.html { redirect_to(:action => 'show', :id => content) }
      format.xml { render :xml => con }
    end
  end

  #============== PRIVATE METHODS

  def check_priv(content)
    return false if content == nil
    return false if content.user_id != session[:user_id]
    true
  end

end

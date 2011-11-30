# -*- coding: utf-8 -*-
require 'net/http'
require 'uri'

class Content < ActiveRecord::Base

  # RELATIONSHIP
  belongs_to :user
  belongs_to :folder
  belongs_to :disclosure
  has_many :schedules, :dependent => :destroy
  has_and_belongs_to_many :parents, :foreign_key => 'child_id', :association_foreign_key => 'parent_id', :class_name => 'Content', :order => 'created_at'
  has_and_belongs_to_many :children, :foreign_key => 'parent_id', :association_foreign_key => 'child_id', :class_name => 'Content', :order => 'created_at'
  has_and_belongs_to_many :tags

  # VALIDATES
  validates_presence_of :title, :user_id, :mimetype, :storagetype, :size
  validate :not_an_url
  validate :cant_upload_when_type_is_url
  #validate :body_and_upload_at_once

  # CONSTANTS
  #STORAGE_PATH = "/Users/eiji/work/coa3_storage"

  FILE = 0
  URL  = 1
  STORAGE = ['ファイル', 'URL']

  TEXTPLAIN = "text/plain"
  OCTETSTREAM = 'application/octet-stream'

  JST = 9 * 3600

  # METHODS
  def self.storage
    [[STORAGE[FILE], FILE], [STORAGE[URL], URL]]
  end

  def self.create_min(title, body, user_id, disclosure_id)
    content = Content.new
    content.title = title
    content.body = body
    content.size = body.size
    content.mimetype = TEXTPLAIN
    content.storagetype = FILE
    content.path = ''
    content.user_id = user_id
    content.disclosure_id = disclosure_id
    content.save
    content
  end

  def initialize(params = nil)
    complement_params(params)
    super
  end

  def save
    st = super
    return false if st == false
    post_save
  end

  def save!
    st = super
    return false if st == false
    post_save
  end

  def update_attributes(params)
=begin
    if mime_type == 'text' || params[:body] != ''
      self.body = params[:body]
    end
    params[:size] = params[:body].size
    params[:path] = "update"
    if params[:storagetype].to_i == URL
      params[:title] = 'abc'
    end
    super
=end
    stat = complement_params(params)
    return stat if stat != true
    super
  end

  def destroy
    File.delete(filepath) if File.exist?(filepath)
    super
  end

  def upload_file=(uploaded)
=begin
    self.body = uploaded.read
    self.size = uploaded.size
    self.mimetype = uploaded.content_type.chomp
    self.path = File.basename(uploaded.original_filename)
=end
  end

  def upload_file
    false
  end

  def body=(data)
    return if data.nil? || data.size == 0
    if self.id == nil
      return if data.nil?
      @temp_path = Const.get('storage_path') +
        "/temp_#{Time.now.strftime("%Y%m%d%H%M%S")}"
      open(@temp_path, 'w') do |fp|
        fp.write(data)
      end
    else
      @temp_path = nil
      open(filepath, 'w') do |fp|
        fp.write(data)
      end
    end
  end

  def body
    data = ""
    begin
      case storagetype
      when URL
        if mime_type == 'text'
          res = get_url_response(path)
          data = res.body
        end
      when FILE
        open(filepath) do |fp|
          data = fp.read
        end
      end
    rescue
    end
    data
  end

  def bodytext
    text = 
      case self.mimetype
      when /^text\//
        body
      when /^image\//
        metainfo
      else
        metainfo
      end
  end

  def filepath
    Const.get('storage_path') + "/#{self.id}"
  end

  def last_access
    accessed_at = self.accessed_at + JST
    date = if accessed_at < Time.now - 24 * 3600 then
             accessed_at.strftime("%Y/%m/%d")
           else
             accessed_at.strftime("%H:%M")
           end
  end

  def size_with_unit
    size = if self.size < 1024 then
             self.size.to_s
           elsif self.size < 1024 * 1024 then
             (self.size / 1024).to_s + 'K'
           else
             (self.size / 1024 / 1024).to_s + 'M'
           end
  end

  def privilege(user_id)
    if self.disclosure != nil
      return self.disclosure.privilege(user_id)
    end
    Grant::UNABLE
  end

  def mime_type
    mimetype.split("/")[0]
  end
  
  def mime_subtype
    mimetype.split("/")[1]
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

  def post_save
    if @temp_path != nil && self.id != nil
      File.rename(@temp_path, Const.get('storage_path') + "/#{self.id}")
      @temp_path = nil
    end
    true
  end

  def url?(path)
    if path =~ /^https?\:\/\/\S+\/\S*$/ then true else false end
  end

  def complement_params(params)
    begin
      if params[:storagetype].to_i == URL
        create_url(params)
      elsif params[:upload_file].class == Tempfile
        create_from_uploaded_file(params)
      elsif url?(params[:body])
        create_from_url(params)
      else
        create_normal(params)
      end
    rescue
      false
    end
    true
  end

  def create_url(params)
    params[:path] = params[:body]
    return if url?(params[:path]) == false
    title, mime, size = get_from_url(params[:path])
    params[:title] = title if params[:title] == ''
    params[:mimetype] = mime
    params[:size] = size
    params[:body] = nil
  end

  def create_from_uploaded_file(params)
    uploaded = params[:upload_file]
    params[:path] = File.basename(uploaded.original_filename)
    params[:title] = params[:path] if params[:title] == ''
    params[:mimetype] = uploaded.content_type.chomp
    params[:storagetype] = FILE
    params[:metainfo] = uploaded.original_filename
    params[:size] = uploaded.size
    params[:body] = uploaded.read
  end

  def create_from_url(params)
    params[:path] = ''
    return if url?(params[:body]) == false
    title, mime, size, body = get_from_url(params[:body])
    params[:title] = title if params[:title] == ''
    params[:mimetype] = mime
    params[:size] = size
    params[:body] = body
  end

  def create_normal(params)
    return if params[:body] == ''
    #params[:mimetype] = TEXTPLAIN if params[:mimetype] !~ /^text\//
    params[:mimetype] = TEXTPLAIN if params[:mimetype] == ''
    params[:size] = params[:body].size
  end

  def get_from_url(path)
    res = get_url_response(path)
    mime = res['content-type']
    bd = res.body
    title = if mime =~ /^text\/html/ then get_title(path, bd)
            else File.basename(path) end
    title = 'index' if title == nil || title == ''
    size = if bd.size == 0 then res['content-length'].to_i else bd.size end
    return title, mime, size, bd
  end

  def get_url_response(path)
    url = URI.parse(path)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.get(url.path)
    end
    res
  end

  def get_title(path, body)
    if body !~ /<title>(.*)<\/title>/ then
      File.basename(path)
    else
      if $1 == nil then '' else $1 end
    end
  end

  def not_an_url
    errors.add(:path, "URLが正しい形式ではありません: '#{path}'") if storagetype == URL && url?(path) == false
  end

  def body_and_upload_at_once
    return if path == ''
    if @temp_path != nil
    #if @temp_path != nil || (self.id != nil && File.exist?(filepath))
      errors.add(:body, "文書内容とファイルのアップロードはどちらか一つにしてください")
    end
  end

  def cant_upload_when_type_is_url
    return if storagetype != URL
    #if @temp_path != nil || (self.id != nil && File.exist?(filepath))
    if @temp_path != nil
      errors.add(:body, "保管タイプがURLのときはファイルのアップロードはできません")
    end
  end

  def need_url_string_when_storagetype_is_url
    return if url?(path)
    errors.add(:body, "保管タイプがURLのときはURL文字列を指定してください")
  end
end

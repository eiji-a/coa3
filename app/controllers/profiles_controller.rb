# -*- coding: utf-8 -*-
class ProfilesController < ApplicationController

  def index
    redirect_to(:action => 'show')
  end

  # GET /profiles/1
  # GET /profiles/1.xml
  def show
    @profile = get_profile
    @gtdprj = Folder.find(@profile.gtd_project_folder)
    @inbox = Content.find(@profile.gtd_inbox)
    @title = "プロファイル: #{@login.name}"
  end

  def edit
    @profile = get_profile
    @title = "プロファイル編集(#{@login.name})"
  end


  def get_profile
    cont = Content.find(:first, :conditions => ['user_id = ? AND mimetype = ?',
                                                session[:user_id],
                                                Profile.mimetype])
    Profile.new(cont)
  end
end

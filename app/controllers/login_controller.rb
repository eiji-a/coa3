# -*- coding: utf-8 -*-
class LoginController < ApplicationController
  def login
    if request.post?
      user = User.authenticate(params[:userid], params[:password])
      if user
        session[:user_id] = user.id
        redirect_to(:action => 'index')
      else
        flash.now[:notice] = 'ユーザ/パスワードが間違っています'
      end
    end
    @title = 'ログイン'
    @uid = params[:userid]
    @pwd = params[:password]
  end

  def logout
    session[:user_id] = nil
    session[:folder_id] = nil
    flash[:notice] = 'ログアウトしました'
    @title = 'ログアウト'
    redirect_to(:action => 'login')
  end

  def index
    redirect_to(:controller => 'folders')
  end

end

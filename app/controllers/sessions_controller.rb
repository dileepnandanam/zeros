class SessionsController < ApplicationController
  def new
  end

  def create
    if params[:provider] == "facebook"
      user = User.find_or_create_by_uid(env["omniauth.auth"][:uid])
      user.update_attributes(access_token: env["omniauth.auth"][:credentials][:token], login: env["omniauth.auth"][:info][:name], avathar: env["omniauth.auth"][:info][:image])
      sign_in(user)
      redirect_back
    else
      user = User.find_by_login(params[:session][:login])
      if user && user.authenticate?(params[:session][:password])
        sign_in(user)
        redirect_back
      else
        render 'new'
        flash[:notice] = 'wrong'
      end
    end
  end

  def destroy
    @current_user = nil
    cookies.permanent[:remember_token] = nil
    redirect_to games_path
  end

  def redirect_back
    if cookies[:return_to].present?
      redirect_to cookies[:return_to]
    else
      redirect_to games_dashboard_path
    end
  end
end

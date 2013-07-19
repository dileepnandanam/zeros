module SessionsHelper
  def current_user
    @current_user ||= User.find_by_remember_token cookies[:remember_token]
    @current_user || User.new
  end

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    @current_user = user
  end
end

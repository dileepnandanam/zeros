class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  before_filter { |c| cookies.permanent[:return_to] = request.path if request.get? && !request.xhr? && request.path != '/auth/facebook/callback' }
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

private
  def current_user
  	uuid = session[:user_uuid]
  	@current_user ||= User.find_by(uuid: uuid) unless uuid.nil?
  	if !uuid.nil? && @current_user.nil?
  		puts "WEIRD!!!"
  		session.delete(:user_uuid)
  	end
  	@current_user
  end
end

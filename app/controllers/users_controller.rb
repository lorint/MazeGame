class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	uuid = SecureRandom.uuid.to_s
  	session[:user_uuid] = uuid
  	u = User.new(name: params[:user][:name], uuid: uuid, user_agent_string: request.env["HTTP_USER_AGENT"])
  	if u.save
	  	redirect_to games_url
	  else
	  	puts u.inspect
	  	redirect_to new_user_path
	  end
  end
end

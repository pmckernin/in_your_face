class SessionsController < ApplicationController
 def create
  begin
    @user = User.from_omniauth(request.env['omniauth.auth'])
    session[:user_id] = @user.id
    flash[:success] = "Welcome, #{@user.name}!"
     
  rescue
    flash[:warning] = "There was an error while trying to authenticate you..."
  end
  redirect_to root_path
 end
 
 def destroy
  if current_user
    session.delete(:user_id)
    flash[:success] = 'See you!'
  end
  redirect_to root_path
 end
 
 def get_user_data
   @client = FitbitAPI::Client.new(client_id: ENV.fetch("O_AUTH_ID"),
                               client_secret: ENV.fetch("FITBIT_SECRET"),
                               access_token: current_user.token,
                               refresh_token: current_user.refresh_token,
                               expires_at: current_user.expires_at,
                               user_id: current_user.uid)
   
  render("/pages/results.html.erb") 
 end
end
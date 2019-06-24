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
   
       # dates = [] 
       # weights = [] 
       # @dates = dates
       # @weights = weights
        counter = 0 
        15.times do   
            #before making the call to the api, looks to see if we already have that weigh in within our database
            check_weigh_in_for_existance = WeighIn.where(:date => Date.today - counter)
                #if the weigh in for a date does not exist, it will call the api and create a new weigh in
            if check_weigh_in_for_existance.count <= 0
                    # @client is the object that makes the call to the api
                   client = @client.weight_logs Date.today - counter 
                   weight = client.fetch("weight") 
                      if weight.first != nil 
                        #if the weigh in exists, it will use the data from the api
                        w = WeighIn.new
                        w.weight = weight.first.fetch("weight").to_f
            
                        w.date = weight.first.fetch("date")
                        w.user_id = current_user.id
                        w.save
                        
                    
                     
                     else
                      
                        w = WeighIn.new 
                         
                        w.date = (Date.today - counter)
                        w.user_id = current_user.id
                        
                        #Check to see if there is a WeighIn before this one.
                        
                        most_recent_weigh_in = WeighIn.where("date < ? AND weight > ?" , Date.today - counter , 5) 
                        
                        
                     
                        
                            if most_recent_weigh_in.present? 
                        
                        #if one exists before this one it will set it equal to the most recent weighIN
                        
                             w.weight = most_recent_weigh_in.first.weight 
                       
                        
                            else 
                        
                        # if one does not exists before this date it will be 0.  
                            w.weight = 0.0
                            end
                       
                        w.save 
                      end 
                      
            # elsif check_weigh_in_for_existance.present? && check_weigh_in_for_existance.first.weight == 1.0
                     
            #             most_recent_weigh_in = WeighIn.where("date < ? AND weight > ?" , Date.today - counter , 5).first
                        
            #             missed_weigh_in = WeighIn.find_by(:date => Date.today - counter)
                          
                          
            #             missed_weigh_in.weight = most_recent_weigh_in.weight
            #             missed_weigh_in.save   
                      
            end
             counter = counter + 1 
         end  
       
   
  render("/pages/results.html.erb") 
 end
 
 
    def api_call
        # api_call_endpoint = "https://api.fitbit.com/1/user/#{current_user.uid}/body/weight/date/today/1w.json"
        
        
        # raw_api_data = open(api_call_endpoint).read
        
        # @parsed_forecast_data = JSON.parse(raw_api_data)
        
        # render("pages/body_time.html.erb")
    end
end
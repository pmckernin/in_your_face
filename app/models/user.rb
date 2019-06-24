class User < ActiveRecord::Base
  class << self
    def from_omniauth(auth_hash)
      user = find_or_create_by(uid: auth_hash['uid'], provider: auth_hash['provider'])
      user.name = auth_hash['info']['name']
      user.weight = auth_hash['extra']['raw_info']["user"]["weight"]
      user.token = auth_hash['credentials']['token']
      user.refresh_token = auth_hash['credentials']['refresh_token']
      user.expires_at = auth_hash["credentials"]["expires_at"]
      user.save!
      user
    end
    
  end
  
  def user_weigh_ins
    WeighIn.where(:user_id => self.id)
  end
 
end

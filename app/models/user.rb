class User < ActiveRecord::Base
  devise :database_authenticatable,
         :omniauthable
  #devise :omniauthable
  attr_accessible :email
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      User.create!(email: data["email"], password: Devise.friendly_token[0,20],
                   facebook_profile: access_token)
    end
  end
end

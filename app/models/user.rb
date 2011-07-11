class User < ActiveRecord::Base
  devise :database_authenticatable, :omniauthable
  attr_accessible :facebook_user_id, :facebook_profile, :facebook_params
  def self.find_for_facebook_oauth(profile_hash)
    user_id = profile_hash['uid']
    if user = User.where(facebook_user_id: user_id).first
      user
    else # Create a user with a stub password.
      User.create!(facebook_user_id: user_id,
                   facebook_profile: profile_hash)
    end
  end
  def self.find_for_facebook_params(params_hash)
    user_id = params_hash[:object]['id']
    if user = User.where(facebook_user_id: user_id).first
      user.update_attributes facebook_params: params_hash
      user
    else # Create a user with a stub password.
      User.create!(facebook_user_id: user_id,
                   facebook_params: params_hash)
    end
  end
  def self.deauthorize(user_id)
    user = self.where(facebook_user_id: user_id).first
    user.destroy if user
  end
  def self.create_from_oauth_token(oauth_token, opts = {})
    api = Koala::Facebook::GraphAPI.new(oauth_token)
    object = api.get_object('me')
    raise "Invalid oauth_token:#{oauth_token} for user_id:#{user_id}" if opts[:user_id] && opts[:user_id] != object['id']
    find_for_facebook_params(object: object, credentials: oauth_token)
  end
  serialize :facebook_profile, Hash
  def facebook
    @facebook ||= Facebook.new(profile: facebook_profile)
  end
  def encrypted_password=(value)
    # nothing to do
  end
  def encrypted_password
    #nothing to do
  end
  def facebook_params=(params)
    self[:facebook_profile] = build_facebook_profile_from_object(params)
  end
  def update_oauth_token(oauth_token)
    current_token = self.facebook_profile['credentials']['token']
    if current_token != oauth_token
      self.facebook_profile['credentials']['token'] = oauth_token
      self.save
    end
  end
  private
  def build_facebook_profile_from_object(params)
    object = params[:object]
    credentials = params[:credentials]
    {
        'provider' => 'facebook',
        'uid' => object['id'],
        'credentials' => {
            'token' => credentials
        },
        'user_info' => {
            'nickname' => object['username'],
            'email' => object['email'],
            'first_name' => object['first_name'],
            'last_name' => object['last_name'],
            'name' => object['name'],
            'image' => "http://graph.facebook.com/#{object['id']}/picture?type=square",
            'urls' => {
                'Facebook' => object['link'],
                'Website' => nil
            }
        },
        'extra' => {
            'user_hash' => object
        }
    }
  end
end

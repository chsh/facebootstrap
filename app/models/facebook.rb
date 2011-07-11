class Facebook
  class Config
    def self.app_id
      @@app_id ||= ENV['FACEBOOK_APP_ID']
    end
    def self.app_secret
      @@app_secret ||= ENV['FACEBOOK_APP_SECRET']
    end
    def self.app_scope
      @@app_scope ||= ENV['FACEBOOK_APP_SCOPE']
    end
  end
  class Profile
    class Hash < HashWithMethod
    end
  end
  class SignedRequest < HashWithMethod
  end
  def initialize(profile_hash)
    @profile = Profile::Hash.from(profile_hash[:profile])
  end
  def profile; @profile end

  def public_graph
    @public_graph ||= Koala::Facebook::GraphAPI.new
  end
  def private_graph()
    @private_graph ||= Koala::Facebook::GraphAPI.new self.profile.credentials.token
  end

  def self.public_graph
    @@public_graph ||= Koala::Facebook::GraphAPI.new
  end

  def self.parse_signed_request(signed_request)
    oauth = Koala::Facebook::OAuth.new(Config.app_id, Config.app_secret)
    SignedRequest.from oauth.parse_signed_request(signed_request)
  end
end

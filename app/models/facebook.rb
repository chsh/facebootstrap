class Facebook
  class Config
    def self.app_id
      @@app_id ||= ENV['FACEBOOK_APP_ID']
    end
    def self.app_secret
      @@app_secret ||= ENV['FACEBOOK_APP_SECRET']
    end
    def self.app_scope
      @@app_scope ||= (ENV['FACEBOOK_APP_SCOPE'] || '').strip.split(',').map(&:to_sym)
    end
  end
  class Profile
    class Hash < HashWithMethod
    end
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
end

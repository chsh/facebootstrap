class Facebook
  class Config
    def self.app_id
      ENV['FACEBOOK_APP_ID']
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

end

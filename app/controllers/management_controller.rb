class ManagementController < ApplicationController
  def deauthorize
    User.deauhtorize(signed_request.user_id)
    render text: 'ok'
  end
  def register_auth_token
    if request.post?
      puts "params:#{params.inspect}"
      User.create_from_oauth_token params[:auth_token], user_id: facebook_user_id
      render text: 'ok'
    else
      render text: 'ng'
    end
  end
end

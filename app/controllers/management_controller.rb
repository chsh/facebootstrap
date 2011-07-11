class ManagementController < ApplicationController
  def deauthorize
    User.deauhtorize(signed_request.user_id)
    render text: 'ok'
  end
  def register_auth_token
    if request.post?
      user = User.create_from_oauth_token params[:auth_token], user_id: facebook_user_id
      save_user_id_to_session user.id
      save_user_to_warden_session user
      render text: 'ok'
    else
      render text: 'ng'
    end
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :parse_signed_request

  def page?
    return false unless signed_request
    page ? true : false
  end
  def page
    @page ||= signed_request.page
  end
  def canvas?
    return false unless signed_request
    !page?
  end
  private
  def parse_signed_request
    if request.post? && params[:signed_request]
      @signed_request = Facebook.parse_signed_request params[:signed_request]
      session[:signed_request] = params[:signed_request]
    elsif request.get? && session[:signed_request]
      @signed_request = Facebook.parse_signed_request session[:signed_request]
    end
    if @signed_request
      user_id = @signed_request[:user_id]
      oauth_token = @signed_request[:oauth_token]
      if user_id
        if oauth_token
          user = User.where(facebook_user_id: user_id).first
          if user
            user.update_oauth_token(oauth_token)
          else
            user = User.create_from_oauth_token(oauth_token)
          end
          @current_user = user
          save_user_to_warden_session(user)
        else
          delete_user_from_warden_session
        end
        save_user_id_to_session(user_id)
      end
    end
  end
  protected
  def verify_post_method
    return if session[:signed_request]
    raise "Method not allowed" unless request.post?
  end
  def facebook_user_id
    session['facebook.user_id']
  end
  def signed_request
    @signed_request
  end
  def save_user_to_warden_session(user)
    session['warden.user.user.key'] = [user.class.to_s, [user.id], nil]
  end
  def delete_user_from_warden_session
    session.delete('warden.user.user.key')
  end
  def warden_session?
    session['warden.user.user.key'] ? true : false
  end
  def save_user_id_to_session(user_id)
    session['facebook.user_id'] = user_id
  end
end

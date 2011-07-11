class Users::SessionsController < Devise::SessionsController
  def new
    redirect_to '/users/auth/facebook'
  end
end

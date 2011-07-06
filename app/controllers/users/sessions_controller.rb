class Users::SessionsController < ApplicationController
  def new
    redirect_to '/users/auth/facebook'
  end
end

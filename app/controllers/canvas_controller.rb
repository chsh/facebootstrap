class CanvasController < ApplicationController
  before_filter :parse_signed_request, only: [:index, :tab]
  def index
  end
  def tab
  end

  private
  def parse_signed_request
    @signed_request = Facebook.parse_signed_request params[:signed_request]
  end

end

class CanvasController < ApplicationController
  before_filter :verify_post_method, only: [:index, :tab]
  def index
  end
  def tab
  end
end

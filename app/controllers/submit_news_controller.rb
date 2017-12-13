class SubmitNewsController < ApplicationController

  layout 'blank'
  after_action :allow_iframe

  def new

  end

  private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

end

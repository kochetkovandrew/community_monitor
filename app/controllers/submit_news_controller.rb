class SubmitNewsController < ApplicationController

  layout 'blank'
  after_action :allow_iframe

  def new

  end

  private

  def allow_iframe
    response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM https://api.vk.com"
  end

end

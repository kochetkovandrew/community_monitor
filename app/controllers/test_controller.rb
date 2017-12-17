class TestController < ApplicationController

  def test
    Rails.logger.debug self.request.env.to_yaml
    redirect_to 'https://spid.center/ru/articles/899'
  end

end
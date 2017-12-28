class TestController < ApplicationController

  def test
    # Rails.logger.debug self.request.env.select{|k,v| k != 'rack.session'}.to_yaml
    redirect_to 'https://spid.center/ru/articles/899'
  end

  def test2
    redirect_to 'http://shvarz.livejournal.com/113839.html'
  end

  def test3
    redirect_to 'http://h-clinic.ru'
  end

  def test4
    redirect_to 'https://pp.userapi.com/c824202/v824202011/69a56/flxa7vod5DE.jpg'
  end

end
class VkOauthController < ApplicationController

  def signin
    redirect_to 'https://oauth.vk.com/authorize?client_id=' + Settings.vk.app_id +
      '&redirect_uri=https://vich.live/vk_oauth/callback' +
      '&display=page' +
      '&v=5.92' +
      '&response_type=code' +
      '&state=HAART'
  end

  def callback
    url = 'https://oauth.vk.com/access_token' +
      '?client_id=' + Settings.vk.app_id +
      '&client_secret=' + Settings.vk.app_secret +
      '&redirect_uri=https://vich.live/vk_oauth/callback' +
      '&code=' + params[:code]
    uri = URI(url)
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    user = User.where(vk_id: json['user_id']).first
    if user
      sign_in(user)
    end
    redirect_to '/'
  end

end

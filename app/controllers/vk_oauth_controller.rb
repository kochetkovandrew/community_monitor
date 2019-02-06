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
    member = Member.find_by_vk_id json['user_id']
    if !member
      member = Member.new(screen_name: json['user_id'])
      member_hash = member.get_from_vk
      member.set_from_vk(member_hash)
      member.is_monitored = false
      member.is_handled = false
      member.save
    end
    session[:current_user_name] = member.full_name
    user = User.where(vk_id: json['user_id']).first
    if user
      sign_in(user)
    end
    redirect_to '/'
  end

end

class VkOauthController < ApplicationController

  def signin
    redirect_to 'https://oauth.vk.com/authorize?client_id=' + Rails.application.credentials.vk[:app_id] +
      '&redirect_uri=https://vich.live/vk_oauth/callback' +
      '&display=page' +
      '&v=5.92' +
      '&response_type=code' +
      '&state=HAART'
  end

  def callback
    url = 'https://oauth.vk.com/access_token' +
      '?client_id=' + Rails.application.credentials.vk[:app_id] +
      '&client_secret=' + Rails.application.credentials.vk[:app_secret] +
      '&redirect_uri=https://vich.live/vk_oauth/callback' +
      '&code=' + params[:code]
    uri = URI(url)
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    if json['user_id']
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
      user = User.where(vk_id: json['user_id']).first_or_create(sign_up_code: Rails.application.credentials.sign_up_code, email: json['user_id'].to_s + '@vk.com')
      if user
        sign_in(user)
      end
    end
    redirect_to '/'
  end

end

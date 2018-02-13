task dead_pages: :environment do
  vk = VkontakteApi::Client.new Settings.vk.dead_pages_token
  step_size = 1000
  owner_id = -97611353
  album_ids = [252401499, 251020128, 249476036, 248272545, 246984490, 245837335,
    244667626, 242778941, 240947059, 238365827, 236543190, 234531859, 232205976,
    229667638, 226558182, 223106790, 219984365, 218061508, 218770323, 220443164]
  all_photos = []
  album_ids.each do |album_id|
    rest = 1
    step = 0
    while rest > 0
      photos = vk_lock { vk.photos.get(owner_id: owner_id, album_id: album_id, count: step_size, offset: step*step_size) }
      all_photos += photos[:items]
      if step == 0
        rest = photos[:count] - step_size
      else
        rest -= step_size
      end
      step += 1
    end
  end
  all_matches = {}
  all_photos.each do |photo|
    all_matches['https://vk.com/photo' + owner_id.to_s + '_' + photo[:id].to_s] = photo[:text].scan(/vk\.com\/([^ \n]*)/)
  end
  all_matches.each do |photo_address, photo_matches|
    photo_matches.flatten!
    photo_matches.reject!{|item| item.match(/^wall.*/)}
    photo_matches.each do |screen_or_id|
      if (matches = screen_or_id.match /^id(\d+)$/)
        id = matches[1]
        member = Member.where(vk_id: id).first
        if member
          puts photo_address + ' https://vk.com/id' + member.vk_id.to_s
        end
      else
        member = Member.where(screen_name: screen_or_id).first
        if member
          puts photo_address + ' https://vk.com/id' + member.vk_id.to_s
        end
      end
    end
  end
end

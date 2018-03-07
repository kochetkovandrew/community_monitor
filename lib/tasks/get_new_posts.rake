task :get_new_posts => :environment do |t, args|
  vk_renew_lock do
    Community.all.each do |community|
      community.get_wall
    end
  end
end

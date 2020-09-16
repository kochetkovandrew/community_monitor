task :get_new_posts => :environment do |t, args|
  vk_renew_lock do
    Community.where('not disabled').all.each do |community|
      begin
        community.get_wall
      rescue => e
        Rails.logger.debug e.message
      end
    end
  end
end

task get_new_comments: :environment do |t|
  vk_renew_lock do
    Community.all.each do |community|
      Post.where(community_id: community.id).order('created_at desc').limit(3).each do |post|
        begin
          post.get_comments(true)
        rescue => e
          Rails.logger.debug e.message
        end
      end
    end
  end
end
task get_new_comments: :environment do |t|
  vk_renew_lock do
    Community.all.each do |community|
      Post.where(community_id: community.id).order('created_at desc').limit(3).each do |post|
        post.get_comments(true)
      end
    end
  end
end
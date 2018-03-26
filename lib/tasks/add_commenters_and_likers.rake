task add_commenters_and_likers: :environment do
  Community.where(monitor_members: true).order(:id).each do |comm|
    commenters = (comm.posts.collect{|post| (post.post_comments.collect{|pc| pc.raw['from_id']} || [])} || []).flatten.compact.sort.uniq
    post_likes = (comm.posts.collect{|post| post.likes} || []).flatten.compact.sort.uniq
    comment_likes = (comm.posts.collect{|post| (post.post_comments.collect{|comment| comment.likes} || []).flatten.compact.sort.uniq} || []).flatten.sort.uniq
    all_users = (commenters + post_likes + comment_likes).reject{|vk_id| vk_id<=0}.sort.uniq
    Member.get_from_vk(all_users, collect_friends: true)
  end
end

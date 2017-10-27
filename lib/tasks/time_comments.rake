task :time_comments => :environment do
  PostComment.all.each do |post_comment|
    hh = JSON::parse post_comment.raw
    post_comment.user_vk_id = hh['from_id']
    post_comment.created_at = Time.at(hh['date'])
    post_comment.likes_count = hh['likes']['count']
    post_comment.save(touch: false)
  end
end
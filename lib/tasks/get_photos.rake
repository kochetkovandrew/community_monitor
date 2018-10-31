task :get_photos => :environment do |t, args|
  comm = Community.find 1
  comm.posts.each do |post|
    Photo::from_entity(post)
    post.post_comments.each do |comment|
      Photo::from_entity(comment)
    end
  end
end
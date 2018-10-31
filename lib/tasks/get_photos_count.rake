task :get_photos_count => :environment do |t, args|
  all_uris = []
  comm = Community.find 1
  comm.posts.each do |post|
    all_uris += Photo::uris_from_entity(post)
    post.post_comments.each do |comment|
      all_uris += Photo::uris_from_entity(comment)
    end
  end
  p all_uris.count
  p all_uris.sort.uniq.count
end
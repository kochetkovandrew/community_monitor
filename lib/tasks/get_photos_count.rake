task :get_photos_count => :environment do |t, args|
  all_uris = []
  comm = Community.find 1
  comm.posts.each do |post|
    uris += Photo::uris_from_entity(post)
    post.post_comments.each do |comment|
      uris += Photo::uris_from_entity(comment)
    end
  end
  p uris.count
  p uris.sort.uniq.count
end
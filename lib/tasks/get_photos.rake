task :get_photos => :environment do |t, args|
  communities = Community.where(id: [1, 2, 3, 4, 5, 8, 9, 15, 17, 19, 21, 22, 23, 24, 26, 27, 28, 33, 35, 36]).all
  communities.each do |community|
    community.posts.each do |post|
      Attachment::from_entity(post)
      post.post_comments.each do |comment|
        Attachment::from_entity(comment)
      end
    end
    community.topics.all do |topic|
      topic.post_comments.each do |comment|
        Attachment::from_entity(comment)
      end
    end
  end
end

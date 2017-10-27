task :save_posts => :environment do
  community = Community.find_by_screen_name 'spida_net'
  posts = JSON::parse File.read(Rails.root.join('applog', 'spida_net_posts.json'))
  posts.each do |post_hash|
    post = Post.create(
      vk_id: post_hash['id'],
      community_id: community.id,
      raw: post_hash.to_json,
    )
  end
end

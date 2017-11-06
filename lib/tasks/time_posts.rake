task :time_posts => :environment do
  Post.all.each do |post|
    hh = JSON::parse post.raw
    post.created_at = Time.at(hh['date'])
    post.save(touch: false)
  end
end
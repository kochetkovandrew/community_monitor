task :get_topic_comments => :environment do
  Topic.where(handled: false).all.each do |topic|
    topic.get_comments
  end
end


task :get_topic_comments => :environment do
  Topic.all.each do |topic|
    topic.get_comments
  end
end


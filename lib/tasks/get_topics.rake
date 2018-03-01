task get_topics: :environment do
  Community.all.each do |community|
    community.get_topics
  end

end
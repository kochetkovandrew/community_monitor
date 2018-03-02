task :get_new_posts => :environment do |t, args|
  Community.all.each do |community|
    community.get_wall
  end
end

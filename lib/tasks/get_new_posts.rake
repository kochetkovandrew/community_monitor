task :get_new_posts => :environment do |t, args|
  Community.where(monitor_members: true).all.each do |community|
    community.get_wall
  end
end

task :print_diff, [:screen_name] => :environment do |t, args|
  community = Community.find_by_screen_name args[:screen_name]
  puts community.screen_name
  puts ''
  community.community_member_histories.order('created_at asc').all.drop(1).reverse.each do |history|
    diff = JSON::parse history.diff
    puts history.created_at.to_s
    puts 'Added:'
    diff['added'].each do |vk_id|
      puts 'https://vk.com/id' + vk_id.to_s
    end
    puts 'Removed:'
    diff['removed'].each do |vk_id|
      puts 'https://vk.com/id' + vk_id.to_s
    end
    puts ''
  end

end
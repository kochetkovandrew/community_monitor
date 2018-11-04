task :get_dialogs => :environment do |t, args|
  vk = VkontakteApi::Client.new Settings.vk.dead_pages_token
  rest = 1
  step = 0
  step_size = 200
  all_messages = []
  cont_flag = true
  while (rest > 0) && cont_flag
    messages = vk_lock { vk.messages.get_history(peer_id: 2000000130, count: step_size, offset: step*step_size) }
    sleep 1
    messages[:items].each do |message|
      all_messages.push message
    end
    if step == 0
      rest = messages[:count] - step_size
    else
      rest -= step_size
    end
    step += 1
#    break if step==10
  end
  p all_messages.count
  all_messages.sort_by! { |message| message[:id] }
  fjson = File.open(Rails.root.join('applog', 'copycat130.json'), 'w')
  fyaml = File.open(Rails.root.join('applog', 'copycat130.yaml'), 'w')
  fjson.puts all_messages.to_json
  fyaml.puts all_messages.to_yaml
end
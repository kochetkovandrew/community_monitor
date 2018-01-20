task :get_messages => :environment do |t, args|
  vk = VkontakteApi::Client.new 'cfb16a3a01101be036d43d6d61213d12301da466e857d8506039d596bda41864e1aa586225fe7d0d4edb6' #ak
  rest = 1
  step = 0
  step_size = 200
  all_dialogs = []
  while rest > 0
    dialogs = vk_lock { vk.messages.get_dialogs(count: step_size, offset: step*step_size) }
    all_dialogs += dialogs[:items]
    if step == 0
      rest = dialogs[:count] - step_size
    else
      rest -= step_size
    end
    step += 1
  end
  f = File.open(Rails.root.join('applog', 'dialogs.yaml'), 'w')
  f.puts all_dialogs.to_yaml
  all_all_messages = {}
  p all_dialogs[0]
  all_dialogs.each do |dialog|
    if dialog[:message][:chat_id].nil?
      idd = dialog[:message][:user_id]
    else
      idd = dialog[:message][:chat_id] + 2000000000
    end
    rest = 1
    step = 0
    step_size = 200
    all_messages = []
    while rest > 0
      messages = vk_lock { vk.messages.get_history(peer_id: idd, count: step_size, offset: step*step_size) }
      all_messages += messages[:items]
      if step == 0
        rest = messages[:count] - step_size
      else
        rest -= step_size
      end
      step += 1
    end
    all_all_messages[idd] = all_messages
  end
  f = File.open(Rails.root.join('applog', 'all_all_messages.yaml'), 'w')
  f.puts all_all_messages.to_yaml

end
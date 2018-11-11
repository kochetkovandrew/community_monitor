task :copy_dialogs => :environment do |t, args|
  vk = VkontakteApi::Client.new Settings.vk.copy_access_token
  copy_dialog = CopyDialog.first
  rest = 1
  step = 0
  step_size = 200
  all_messages = []
  last_id = copy_dialog.last_message_id || 0
  cont_flag = true
  while (rest > 0) && cont_flag
    messages = vk_lock { vk.messages.get_history(peer_id: copy_dialog.source_id, count: step_size, offset: step*step_size) }
    messages[:items].each do |message|
      if message[:id] > last_id
        all_messages.push message
      else
        cont_flag = false
        break
      end
    end
    if step == 0
      rest = messages[:count] - step_size
    else
      rest -= step_size
    end
    step += 1
  end
  all_messages.sort_by! { |message| message[:id] }
  begin
    all_messages.each do |message|
      cm = CopyMessage.new(
        user_vk_id: message[:user_id],
        vk_id: message[:id],
        body: message[:body],
        raw: message,
      )
      cm.created_at = Time.at(message[:date])
      cm.save
    end
  rescue
  end
  if !all_messages.empty?
    last_id = all_messages.last[:id]
  end
  copy_dialog.last_message_id = last_id
  copy_dialog.save
end
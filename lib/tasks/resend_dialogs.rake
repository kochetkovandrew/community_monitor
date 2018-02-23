task :resend_dialogs => :environment do |t, args|
  vk = VkontakteApi::Client.new Settings.vk.copy_access_token
  copy_dialog = CopyDialog.first
  rest = 1
  step = 0
  step_size = 200
  all_messages = []
  last_id = copy_dialog.last_resent_message_id || 0
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
  if !all_messages.empty?
    last_id = all_messages.last[:id]
  end
  all_ids = all_messages.collect {|message| message[:id]}
  i = copy_dialog.copy_id
  while !(ids = all_ids.shift(25)).empty?
    i += 1
    msg = 'copy' + i.to_s
    vk_lock { vk.messages.send(peer_id: copy_dialog.recipient_id, message: msg, forward_messages: ids) }
    sleep 5
  end
  copy_dialog.copy_id = i
  copy_dialog.last_resent_message_id = last_id
  copy_dialog.save
end
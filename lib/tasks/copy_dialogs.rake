task :copy_dialogs => :environment do |t, args|
  CopyDialog.where('access_token is not null').where(id: 14).all.each do |copy_dialog|
    vk = VkontakteApi::Client.new copy_dialog.access_token
    rest = 1
    step = 0
    step_size = 200
    last_id = copy_dialog.last_message_id || 0
    new_last_id = last_id
    cont_flag = true
    while (rest > 0) && cont_flag
      messages = vk_lock { vk.messages.get_history(peer_id: copy_dialog.source_id, count: step_size, offset: step*step_size) }
      all_messages = []
      messages[:items].each do |message|
        if message[:id] > last_id
          all_messages.push message
        else
         cont_flag = false
         break
        end
        if message[:id] > new_last_id
          new_last_id = message[:id]
        end
      end
      all_messages.sort_by! { |message| message[:id] }
      begin
        all_messages.each do |message|
          cm = CopyMessage.new(
            user_vk_id: (copy_dialog.source_id < 2000000000) ? message[:from_id] : message[:user_id],
            vk_id: message[:id],
            body: message[:body],
            raw: message,
            copy_dialog_id: copy_dialog.id,
            )
          cm.created_at = Time.at(message[:date])
          cm.save
        end
      rescue
      end
      if step == 0
        rest = messages[:count] - step_size
      else
        rest -= step_size
      end
      step += 1
    end
    copy_dialog.last_message_id = new_last_id
    copy_dialog.save
  end
end

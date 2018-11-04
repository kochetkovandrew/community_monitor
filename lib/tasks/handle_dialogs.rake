task handle_dialogs: :environment do
  CopyDialog.where('id <> ?', 1).all.each do |copy_dialog|
    fjson = File.read(Rails.root.join('applog', 'copycat' + (copy_dialog.source_id % 1000000000).to_s + '.json'))
    all_messages = JSON.parse fjson
    all_messages.sort_by! { |message| message['id'] }
    all_messages.each do |message|
      cm = CopyMessage.new(
        copy_dialog_id: copy_dialog.id,
        user_vk_id: message['user_id'],
        body: message['body'],
        vk_id: message['id'],
        raw: message.to_json,
      )
      cm.created_at = Time.at(message['date'])
      cm.save
    end
    if !all_messages.empty?
      last_id = all_messages.last['id']
    end
    copy_dialog.last_message_id = last_id
    copy_dialog.save
  end
end
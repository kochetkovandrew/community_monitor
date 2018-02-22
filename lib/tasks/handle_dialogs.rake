task handle_dialogs: :environment do
  fjson = File.read(Rails.root.join('applog', 'copycat.json'))
  data = JSON.parse fjson
  data.each do |message|
    if message['fwd_messages']
      message['fwd_messages'].each do |fwd_message|
        cm = CopyMessage.new(
          user_vk_id: fwd_message['user_id'],
          body: fwd_message['body'],
          raw: fwd_message.to_json,
        )
        cm.created_at = Time.at(fwd_message['date'])
        cm.save
      end
    end
  end
end
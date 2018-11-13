task handle_copy_messages: :environment do
  def rec(raw)
    Attachment::from_raw(raw)
    if raw['fwd_messages']
      raw['fwd_messages'].each do |submessage|
        rec(submessage)
      end
    end
  end

  CopyMessage.where(copy_dialog_id: 1).order(:id).each do |copy_message|
    rec(copy_message.raw)
  end
end
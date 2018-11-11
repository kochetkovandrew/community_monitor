module CopyMessagesHelper

  def text_cite(raw, level = 0, attachments = [])
    member = Member.find_by_vk_id raw['user_id']
    time = Time.at raw['date']
    text = '>' * level
    text += ' ' if level > 0
    text += "[id" + member.vk_id.to_s + '|' + member.full_name + '] в ' + time.in_time_zone('Europe/Moscow').to_s + "\n"
    text += ('>' * level)
    text += ' ' if level > 0
    text += raw['body']
    att_loc = Attachment::from_raw(raw)
    Rails.logger.debug 'attachments'
    Rails.logger.debug att_loc
    attachments += att_loc
    if !raw['fwd_messages'].nil?
      raw['fwd_messages'].each do |fwd_message|
        text += "\n"
        fwd_cite = text_cite(fwd_message, level+1, attachments)
        text += fwd_cite[:text]
        attachments += fwd_cite[:attachments]
      end
    end
    {text: text, attachments: attachments}
  end

end

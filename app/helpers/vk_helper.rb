module VkHelper

  def entry_raw_body(raw_entry)
    res = '<p>'
    res += comment_body(raw_entry['text'])
    res += '</p>'
    if raw_entry['attachments']
      raw_entry['attachments'].each do |attachment|
        res += attachment_body(attachment)
      end
    end
    res
  end

  def entry_body(entry)
    res = '<p>'
    res += entry.created_at.to_s
    if entry.kind_of?(PostComment)
      if !entry.post.nil?
        res += link_to (fa_icon('comment') + ' Ссылка'), comment_link(entry)
      elsif !entry.topic.nil?
        res += link_to (fa_icon('comments') + ' Ссылка'), comment_link(entry)
      end
    end
    res += '<br/>'
    res += comment_body(entry.raw['text'])
    res += '</p>'
    if !entry.raw['copy_history'].nil?
      cnt = 0
      entry.raw['copy_history'].each do |child_entry|
        res += '<div class="im_fwd_log_wrap">'.html_safe
        res += entry_raw_body(child_entry)
        cnt += 1
      end
      for i in 1..cnt
        res += '</div>'.html_safe
      end
    end

    if entry.raw['attachments']
      entry.raw['attachments'].each do |attachment|
        res += attachment_body(attachment)
      end
    end
    res.html_safe
  end

  def comment_body(raw_vk_text)
    parts = raw_vk_text.split(/(\[(?:club|id)\d+(?::[^\|]*)?\|[^\]]+\])/)
    res = ''
    parts.each do |part|
      matches = /^\[((?:club|id)\d+)(?::[^\|]*)?\|([^\]]+)\]$/.match part
      if matches
        res += link_to(matches[2], 'https://vk.com/' + matches[1])
      else
        res += part
      end
    end
    res.split("\n").join('<br/>').html_safe
  end

  def attachment_body(attachment)
    res = ''
    case attachment['type']
    when 'photo'
      href = '#'
      attachment['photo'].each do |k,v|
        if /^photo_/.match(k)
          href = v
        end
      end
      res += link_to(image_tag(attachment['photo']['photo_75']), href, target: '_blank')
    when 'doc'
      if attachment['doc']['ext'] == 'ogg'
        res += audio_tag(attachment['doc']['url'], controls: true)
      else
        res += link_to attachment['doc']['title'], attachment['doc']['url'], target: '_blank'
      end
    when 'audio'
      res += link_to (content_tag('i', '', class: 'fa fa-music') + ' ' + attachment['audio']['title']), attachment['audio']['url'], target: '_blank'
    when 'sticker'
      res += image_tag(attachment['sticker']['photo_64'])
    when 'link'
      if !attachment['link']['photo'].nil?
        link_to(content_tag(:i, '', class: 'fa fa-link') + ' ' + image_tag(attachment['link']['photo']['photo_75'], title: attachment['link']['title']), attachment['link']['url'], target: '_blank')
      else
        link_to(attachment['link']['title'], attachment['link']['url'], target: '_blank')
      end
    when 'video'
      href = ('https://vk.com/video' + attachment['video']['owner_id'].to_s + '_' + attachment['video']['id'].to_s)
      if attachment['video']['is_private'] == 1
        id = attachment['video']['owner_id'].to_s + '_' + attachment['video']['id'].to_s + '_' + attachment['video']['access_key']
      end
      res += link_to (content_tag('i', '', class: 'fa fa-caret-right fa-lg fa-fw') + ' ' + attachment['video']['title']), href, target: '_blank'
    when 'wall'
      res += attachment.to_json
    else
      res += attachment['type']
    end
    res.html_safe
  end

  def message_body(message)
    res = link_to(content_tag(:span, '', :class => 'im-avatar', 'data-user-vk-id' => message['user_id']), 'https://vk.com/id' + message['user_id'].to_s)
    res += content_tag(:span, DateTime.strptime(message['date'].to_s,'%s').strftime('%Y-%m-%d %H:%M:%S'), class: 'im_time')
    res += content_tag(:div, message['body'])
    if message['attachments']
      res += '<div class="im-attachments">'.html_safe
      message['attachments'].each do |attachment|
        res += content_tag(:span, attachment_body(attachment))
      end
      res += '</div>'.html_safe
    end
    if message['fwd_messages']
      message['fwd_messages'].each do |child_message|
        res += '<div class="im_fwd_log_wrap">'.html_safe
        res += message_body(child_message)
        res += '</div>'.html_safe
      end
    end
    res.html_safe
  end

  def comment_link(comment)
    href = 'https://vk.com/'
    if !comment.topic.nil?
      if !comment.topic.community.nil?
        href += 'topic'
        href += (-comment.topic.community.vk_id).to_s
        href += '_'
        href += comment.topic.vk_id.to_s
        href += '?post='
        href += comment.vk_id.to_s
      end
    end
    href
  end

end
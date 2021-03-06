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

  def entry_body(entry, show_links=true)
    res = ''
    if entry.kind_of?(PostComment)
      res += link_to(content_tag(:span, '', :class => 'im-avatar', 'data-user-vk-id' => entry.user_vk_id), 'https://vk.com/id' + entry.user_vk_id.to_s)
      res += '<div class="entry-message">'
      if entry.user_vk_id > 0
        res += link_to(
          content_tag(:span, '', :class => 'im-name vk-link', 'data-user-vk-id' => entry.user_vk_id),
          'https://vk.com/id' + entry.user_vk_id.to_s,
          { class: 'btn btn-sm btn-outline-primary', role: 'button'})
        res += link_to fa_icon(:info, class: 'fa-sm fa-fw'), {controller: :members, action: :show, id: entry.user_vk_id}, { class: 'btn btn-sm btn-outline-primary', role: 'button'}
      end
    end
    res += '<p>'
    if entry.kind_of?(Post)
      res += content_tag(:span, l(entry.created_at, format: '%-d %B %Y в %H:%M:%S'), class: :time)
      res += link_to (fa_icon('vk')), post_link(entry), { class: 'btn btn-sm btn-outline-primary', role: 'button'}
    end
    res += '<br/>'
    if entry.kind_of?(Topic)
      res += comment_body(entry.raw['title'])
      res += link_to (fa_icon('vk')), topic_link(entry), { class: 'btn btn-sm btn-outline-primary', role: 'button'}
    else
      res += comment_body(entry.raw['text'])
    end
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
    res2 = ''
    if entry.kind_of?(Post) || entry.kind_of?(Topic)
      if show_links
        res2 += link_to(entry.post_comments.count.to_s + ' ' + t(:comment, count: entry.post_comments.count), entry, { class: 'btn btn-sm btn-outline-primary', role: 'button'})
      else
        res2 += button_tag(entry.post_comments.count.to_s + ' ' + t(:comment, count: entry.post_comments.count), {class: 'btn btn-sm btn-outline-primary', role: 'button'})
      end
    end
    if !entry.kind_of?(Topic)
      res2 += content_tag(:div, fa_icon(:heart, class: 'fa-vk-color') + ' Нравится ' + (entry.likes.try(:count) || 0).to_s, { class: 'likes btn btn-sm btn-outline-primary'})
    end
    res += content_tag(:div, res2.html_safe)
    if entry.kind_of?(PostComment)
      res += content_tag(:span, l(entry.created_at, format: '%-d %B %Y в %H:%M:%S'), class: :time)
      if !entry.post.nil? || !entry.topic.nil?
        res += link_to (fa_icon('vk')), comment_link(entry), { class: 'btn btn-sm btn-outline-primary', role: 'button'}
      end
      res += '</div>'
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
        tr = ''
        begin
          host = URI.parse(attachment['link']['url']).host
          lefttd = content_tag(:td, '', {href: attachment['link']['url'], target: '_blank', class: 'page_media_link_thumb', style: "background-image: url(#{attachment['link']['photo']['photo_75']}); background-size: 49px 49px;"})
          txtlink = link_to(attachment['link']['title'], attachment['link']['url'], target: '_blank', class: 'page_media_link_title')
          hostlink = link_to(host, attachment['link']['url'], target: '_blank', class: 'page_media_link_url')
          divrighttd = content_tag(:div, txtlink + "\n" + hostlink, class: 'page_media_link_desc_wrap')
          righttd = content_tag(:td, divrighttd, class: 'page_media_link_desc_td')
          tr = content_tag(:tr, lefttd + righttd)
        rescue
        end
        table = content_tag(:table, tr, {cellpadding: 0, cellspacing: 0})
        res += table
      else
        begin
          res += link_to(attachment['link']['title'], attachment['link']['url'], target: '_blank')
        rescue
        end
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
    if !message['from_id'].nil?
      user_vk_id = message['from_id']
    else
      user_vk_id = message['user_id']
    end

    res = link_to(
      content_tag(:span, '', :class => 'im-name vk-link', 'data-user-vk-id' => user_vk_id),
      'https://vk.com/id' + user_vk_id.to_s,
      { class: 'btn btn-sm btn-outline-primary', role: 'button'})
    res += link_to fa_icon(:info, class: 'fa-sm fa-fw'), {controller: :members, action: :show, id: user_vk_id}, { class: 'btn btn-sm btn-outline-primary', role: 'button'}

    # archive_select = 'Архив: '.html_safe +
    #   select_tag('archive_topic', options_for_select( [""] +
    #     Community.
    #       where(screen_name: Settings.vk.archive_community).
    #       first.
    #       topics.
    #       order('updated_at desc').
    #       collect{|topic| [topic.title, topic.id, ]}))
    #   archive_select += button_tag('Добавить', {type: :button, class: 'message_archive_topic_button'})
    #   res += content_tag(:p, archive_select)
      res += content_tag(:p, '', {class: 'copy_message_topic'})
      res += content_tag(:p,
      content_tag(:span, l(Time.at(message['date']), format: '%-d %B %Y в %H:%M:%S'), class: :time) +
      content_tag(:div, message['body'])
    )
    if message['attachments']
      res += content_tag(:div,
        message['attachments'].collect{|attachment| content_tag(:span, attachment_body(attachment))}.join().html_safe,
        class: 'im-attachments')
    end
    if message['fwd_messages']
      message['fwd_messages'].each do |child_message|
        res += content_tag(:div, content_tag(:span, message_body(child_message)), class: 'im_fwd_log_wrap')
      end
    end
    link_to(content_tag(:span, '', :class => 'im-avatar', 'data-user-vk-id' => user_vk_id), 'https://vk.com/id' + user_vk_id.to_s) +
      content_tag(:div, res, class: 'im-message')
  end

  def post_link(post)
    href = 'https://vk.com/'
    if !post.community.nil?
      href += 'wall'
      href += (-post.community.vk_id).to_s
      href += '_'
      href += post.vk_id.to_s
    end
    href
  end

  def topic_link(topic)
    href = 'https://vk.com/'
    if !topic.community.nil?
      href += 'topic'
      href += (-topic.community.vk_id).to_s
      href += '_'
      href += topic.vk_id.to_s
    end
    href
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
    elsif !comment.post.nil?
      if !comment.post.community.nil?
        href += 'wall'
        href += (-comment.post.community.vk_id).to_s
        href += '_'
        #href += comment.post.vk_id.to_s
        #href += '?post='
        href += comment.vk_id.to_s
      end
    end
    href
  end

end
module VkHelper
  def comment_body(raw_vk_text)
    parts = raw_vk_text.split(/(\[(club|id)\d+\|[^\]]+\])/)
    skip_next = false
    res = ''
    parts.each do |part|
      if skip_next
        skip_next = false
        next
      end
      matches = /^\[((club|id)\d+)\|([^\]]+)\]$/.match part
      if matches
        skip_next = true
        res += link_to(matches[3], 'https://vk.com/' + matches[1])
      else
        res += part
      end
    end
    res.html_safe
  end
end
task memory_dates: :environment do
  next_date = Date.today + 1
  memory_dates = MemoryDate.where(month: next_date.month).where(day: next_date.day).order('year asc').all
  if !memory_dates.empty?
    vk = VkontakteApi::Client.new Settings.vk.user_access_token
    message = "Памятные даты завтра:\n"
    memory_dates.each do |memory_date|
      if !memory_date.year.nil?
        message += memory_date.year.to_s + ": "
      end
      if memory_date.kind == 'birth'
        message += "родился "
      end
      if memory_date.kind == 'death'
        message += "умер "
      end
      message += memory_date.description + "\n"
    end
    vk_lock do
      vk.messages.send(user_id: 305013709, message: message)
    end
  end
end
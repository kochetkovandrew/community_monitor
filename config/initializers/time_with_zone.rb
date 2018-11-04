module ActiveSupport
  class TimeWithZone
    def to_vk_time(tz)
      months = ['янв', 'фев', 'мар', 'апр', 'мая', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек']
      cur_time = ActiveSupport::TimeZone[tz].now
      post_time = self.in_time_zone(tz)
      if post_time.year != cur_time.year
        post_time.day.to_s + ' ' + months[post_time.month-1] + ' ' + post_time.year.to_s
      else
        post_time.day.to_s + ' ' + months[post_time.month-1] + ' в ' + post_time.hour.to_s + ':' + post_time.min.to_s.rjust(2,'0')
      end
    end
  end
end
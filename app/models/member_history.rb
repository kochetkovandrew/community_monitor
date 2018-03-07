class MemberHistory < ActiveRecord::Base

  belongs_to :member

  def comparable_hash
    {
      sex: self.raw['sex'],
      city_id: self.raw['city'].nil? ? nil : self.raw['city']['id'],
      city_title: self.raw['city'].nil? ? '' : (self.raw['city']['title'] || ''),
      country_id: self.raw['country'].nil? ? nil : self.raw['country']['id'],
      country_title: self.raw['country'].nil? ? '' : (self.raw['country']['title'] || ''),
      nickname: (self.raw['nickname'] || ''),
      last_name: (self.last_name || ''),
      first_name: (self.first_name || ''),
    }
  end

end

class Member < ActiveRecord::Base
  has_many :community_members
  has_many :communities, :through => :community_members

end

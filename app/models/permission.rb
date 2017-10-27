class Permission < ActiveRecord::Base
  has_many :permission_users
  has_many :users, through: :permission_users
end
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :sign_up_code
  validates :sign_up_code,
            on: :create,
            presence: true,
            inclusion: { in: [Settings.sign_up_code] }
  has_many :permission_users
  has_many :permissions, through: :permission_users

end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :sign_up_code
  validates :sign_up_code,
            on: :create,
            presence: true,
            inclusion: { in: [Rails.application.credentials.sign_up_code] }
  has_many :permission_users
  has_many :permissions, through: :permission_users

  def password_required?
    return false if !vk_id.nil?
    super
  end

  def email_required?
    return false if !vk_id.nil?
    super
  end

  def has_permission?(permission_name)
    permission_name.in?(permissions.all.collect{|permission| permission.name})
  end

  def has_permission_id?(permission_id)
    permission_id.in?(permission_users.all.collect{|permission_user| permission_user.permission_id})
  end

  def admin_of
    return [] if vk_id.nil?
    CommunityKey.where("admins::jsonb @> '?'::jsonb", vk_id)
  end

end

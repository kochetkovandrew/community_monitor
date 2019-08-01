class Shortlink < ActiveRecord::Base
  # before_save :set_shortlink
  #
  # def set_shortlink
  #   if shortlink.nil?
  #
  #   end
  # end
  def short
    '/short/' + (id + 1048576).to_s(36)
  end
end

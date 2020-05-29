class Shortlink < ActiveRecord::Base

  def short
    '/short/' + (id + 1048576).to_s(36)
  end

end

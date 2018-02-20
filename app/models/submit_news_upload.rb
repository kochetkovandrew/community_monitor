class SubmitNewsUpload < ActiveRecord::Base
  belongs_to :submit_news
  belongs_to :upload
end

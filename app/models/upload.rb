class Upload < ActiveRecord::Base
  has_many :submit_news_uploads
  has_many :submit_news, through: :submit_news_uploads
end

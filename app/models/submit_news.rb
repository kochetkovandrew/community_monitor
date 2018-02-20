class SubmitNews < ActiveRecord::Base
  belongs_to :community
  has_many :submit_news_uploads
  has_many :uploads, through: :submit_news_uploads
end

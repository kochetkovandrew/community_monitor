task get_topics: :environment do
  Community.where('not disabled').all.each do |community|
    begin
      community.get_topics
    rescue => e
      Rails.logger.debug e.message
    end
  end

end
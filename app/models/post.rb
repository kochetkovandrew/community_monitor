class Post < ActiveRecord::Base


  def self.new_or_create_from_wall(wall_item, source)
    post = Post.where(source).where(relative_id: wall_item[:id]).first
    copy_history = []
    if !wall_item[:copy_history].nil?
      wall_item[:copy_history].each do |history_item|
        copy_history.push({
                            from_id: history_item[:from_id].abs,
                            from_community: (history_item[:from_id] < 0),
                            published_at: Time.at(history_item[:date]).to_datetime,
                            text: history_item[:text]
                          })
      end
    end
    if post.nil?
      post = Post.new(
        body: wall_item[:text],
        copy_history: copy_history.to_json,
        from_id: wall_item[:from_id],
        published_at: Time.at(wall_item[:date]).to_datetime,
        relative_id: wall_item[:id],
      )
    end
    if !wall_item[:attachments].nil?
      puts wall_item[:attachments].to_yaml
    end
    post
  end

end

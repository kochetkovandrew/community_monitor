class PurgeController < ApplicationController

  def index
    @access_key = params[:access_key]
    if !@access_key.nil?
      vk = VkontakteApi::Client.new @access_key
      @response = vk_lock { vk.newsfeed.get_comments(count: 50) }
    end
  end

  def update
    @access_key = params[:access_key]
    if !@access_key.nil?
      vk = VkontakteApi::Client.new @access_key
      @acc_info = vk_lock { vk.account.get_profile_info }
      @member_id = @acc_info.id
      params[:posts].each do |item|
        post_info = item[1]
        case post_info[:type]
        when 'post'
          comments = []
          step_size = 100
          begin
            rest = 1
            step = 0
            while rest > 0
              comments_chunk = vk_lock { vk.wall.get_comments(owner_id: post_info[:source_id].to_i, post_id: post_info[:post_id].to_i, count: step_size, offset: step*step_size, sort: 'desc') }
              if step == 0
                rest = comments_chunk[:count] - step_size
              else
                rest -= step_size
              end
              step += 1
              items = comments_chunk[:items]
              comments += items
            end
          end
          comments.each do |comment|
            if comment[:from_id] == @member_id
              Rails.logger.debug comment
              begin
                vk_lock { vk.wall.delete_comment(owner_id: post_info[:source_id].to_i, comment_id: comment[:id])}
              rescue
                Rails.logger.debug 'delete failed'
              end
            end
          end
        when 'topic'
          comments = []
          step_size = 100
          begin
            rest = 1
            step = 0
            while rest > 0
              comments_chunk = vk_lock { vk.board.get_comments(group_id: -post_info[:source_id].to_i, topic_id: post_info[:post_id].to_i, count: step_size, offset: step*step_size, need_likes: 1, sort: 'desc') }
              if step == 0
                rest = comments_chunk[:count] - step_size
              else
                rest -= step_size
              end
              step += 1
              items = comments_chunk[:items]
              comments += items
            end
          end
          comments.each do |comment|
            if comment[:from_id] == @member_id
              Rails.logger.debug comment
              begin
                vk_lock { vk.board.delete_comment(group_id: -post_info[:source_id].to_i, topic_id: post_info[:post_id].to_i, comment_id: comment[:id]) }
              rescue
                Rails.logger.debug 'delete failed'
              end
            end
          end
        end
      end
    end
  end

end
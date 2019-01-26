class CopyMessagesDatatable < ApplicationDatatable
  delegate :params, :link_to, :select_tag, :options_for_select, :content_tag, :message_body, to: :@view

  def as_json(options = {})
    aaData = data
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: CopyMessage.count,
      iTotalDisplayRecords: objects.total_entries,
      aaData: aaData,
      avatars: avatars,
    }
  end

  private

  def avatars
    members = Member.where(vk_id: @user_ids).all
    member_vk_ids = members.collect{|member| member.vk_id}
    not_known = @user_ids - member_vk_ids
    new_members = []
    not_known.reject!{|id| id < 0}
    if !not_known.empty?
      not_known.each do |vk_id|
        member = Member.new(screen_name: vk_id, manually_added: false)
        member.set_from_vk
        if member.screen_name.nil?
          member.screen_name = 'id' + member.vk_id.to_s
        end
        member.save
        new_members.push member
      end
    end
    res = {}
    (members + new_members).each do |member|
      avatar = 'https://vk.com/images/camera_50.png'
      full_name = 'Неизвестно'
      begin
        full_name = member.raw['first_name'] + ' ' + member.raw['last_name']
        avatar = member.raw['photo_50']
      rescue
      end
      res[member.vk_id] = {full_name: full_name, avatar: avatar}
    end
    res
  end

  def collect_avatars(raw_message)
    @user_ids ||= []
    if !raw_message['from_id'].nil?
      @user_ids.push raw_message['from_id']
    else
      @user_ids.push raw_message['user_id']
    end
    if raw_message['fwd_messages']
      raw_message['fwd_messages'].each do |child_raw_message|
        @user_ids += collect_avatars(child_raw_message)
      end
    end
    @user_ids.uniq! || []
  end

  def search_keys
    {"raw::json #>> '{}'" => :string}
  end

  def data
    @user_ids ||= []
    objects.map do |copy_message|
      body = copy_message.body
      collect_avatars(copy_message.raw)
      {
        created_at: copy_message.created_at,
        body: message_body(copy_message.raw),
        DT_RowAttr: {
          'data-id' => copy_message.id,
          'data-topic-id' => copy_message.try(:topic_id),
          'data-topic-title' => copy_message.try(:topic).try(:title)
        },
      }
    end
  end

  def fetch_query
    CopyMessage.where(copy_dialog_id: params[:copy_dialog_id]).includes([:topic])
  end

  def sort_column
    columns = %w[
      created_at
    ]
    columns[params[:iSortCol_0].to_i]
  end

end
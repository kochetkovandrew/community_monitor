class CopyMessagesDatatable
  delegate :params, :link_to, :select_tag, :options_for_select, :content_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    aaData = data
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: CopyMessage.count,
      iTotalDisplayRecords: copy_messages.total_entries,
      aaData: aaData,
      avatars: avatars,
    }
  end

  private

  def render_message(message)
    ActionController::Base.new.render_to_string(
      template: 'copy_messages/_message',
      format: [:html],
      locals: { message: message }
    )
  end

  def avatars
    p @user_ids
    members = Member.where(vk_id: @user_ids).all
    member_vk_ids = members.collect{|member| member.vk_id}
    not_known = @user_ids - member_vk_ids
    new_members = []
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
        parsed = JSON.parse(member.raw)
        full_name = parsed['first_name'] + ' ' + parsed['last_name']
        avatar = parsed['photo_50']
      rescue
      end
      res[member.vk_id] = {full_name: full_name, avatar: avatar}
    end
    res
  end

  def collect_avatars(raw_message)
    @user_ids ||= []
    @user_ids.push raw_message['user_id']
    if raw_message['fwd_messages']
      raw_message['fwd_messages'].each do |child_raw_message|
        @user_ids += collect_avatars(child_raw_message)
      end
    end
    @user_ids.uniq!
  end

  def data
    copy_messages.map do |copy_message|
      body = copy_message.body
      raw = JSON.parse(copy_message.raw)
      collect_avatars raw
      {
        created_at: copy_message.created_at,
        body: render_message(raw),
        DT_RowAttr: { 'data-id' => copy_message.id },
      }
    end
  end

  def copy_messages
    @copy_messages ||= fetch_copy_messages
  end

  def fetch_copy_messages
    copy_messages = CopyMessage.order("#{sort_column} #{sort_direction} NULLS LAST")
    copy_messages = copy_messages.page(page).per_page(per_page)
    if params[:sSearch].present?
      copy_messages = copy_messages.where("raw ilike :search", search: "%#{params[:sSearch]}%")
    end
    copy_messages
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[
      created_at
    ]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
class PostCommentsDatatable < ApplicationDatatable
  delegate :link_to, :select_tag, :options_for_select, :content_tag, :entry_body, :t, to: :@view

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: PostComment.where(post_id: params[:id]).count,
      iTotalDisplayRecords: objects.total_entries,
      aaData: data,
      avatars: avatars,
    }
  end

  private

  def avatars
    members = Member.where(vk_id: @member_vk_ids).all
    member_vk_ids = members.collect{|member| member.vk_id}
    not_known = @member_vk_ids - member_vk_ids
    new_members = []
    if !not_known.empty?
      not_known.each do |vk_id|
        next if vk_id < 0
        member = Member.new(screen_name: vk_id, manually_added: false)
        member.set_from_vk
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

  def search_keys
    {"(raw #>> '{body}')" => :string}
  end

  def data
    @member_vk_ids ||= []
    objects.map do |post_comment|
      @member_vk_ids.push post_comment.user_vk_id
      {
        body: entry_body(post_comment),
        DT_RowAttr: { 'data-id': post_comment.id },
      }
    end
  end

  def fetch_query
    PostComment.where(post_id: params[:id])
  end

  def sort_column
    columns = %w[
      created_at
    ]
    columns[params[:iSortCol_0].to_i]
  end

end
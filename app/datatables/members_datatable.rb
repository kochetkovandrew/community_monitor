class MembersDatatable < ApplicationDatatable
  delegate :link_to, :select_tag, :image_tag, :options_for_select, :content_tag, :fa_icon, to: :@view

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Member.total_count,
      iTotalDisplayRecords: members.total_entries,
      aaData: data
    }
  end

  private

  def search_keys
    {'first_name' => :string, 'last_name' => :string, 'screen_name' => :string, 'vk_id' => :integer}
  end

  def data
    members.map do |member|
      {
        vk_id: content_tag(:div, image_tag(member.raw['photo_50'] || 'https://vk.com/images/camera_50.png'), class: 'list-avatar') + ' ' +
          content_tag(:p, ((member.is_friend == false ? '' : fa_icon("handshake-o") + ' ') + member.vk_id.to_s), class: 'members_vk_id'),
        full_name: member.first_name.to_s + ' ' + member.last_name.to_s,
        last_seen_at: member.last_seen_at.nil? ? '' : member.last_seen_at,
        links:
          link_to(fa_icon('vk', class: 'fa-lg fa-fw'), 'https://vk.com/id' + member.vk_id.to_s, { class: 'btn btn-sm btn-outline-primary', role: 'button'}) +
          link_to(content_tag(:i, '', class: 'fa fa-info fa-lg fa-fw'), {controller: :members, action: :show, id: member.vk_id}, { class: 'btn btn-sm btn-outline-primary', role: 'button', title: 'Показать'}) +
          select_tag('member[status]', options_for_select(
            [
              ['Не просмотрен', 'not_viewed', {:class => 'ui-icon-notice', 'data-content' => "<span class='label label-info'>Не просмотрен</span>"}],
              ['Неизвестно', 'no_info', {:class => 'ui-icon-notice', 'data-content' => "<span class='label label-info'>Неизвестно</span>"}],
              ['Внимание', 'warning', {:class => 'ui-icon-notice', 'data-content' => "<span class='label label-warning'>Внимание</span>"}],
              ['Умер', 'dead', {:class => 'ui-icon-notice', 'data-content' => "<span class='label label-danger'>Умер</span>"}],
              ['Обработан', 'handled', {:class => 'ui-icon-notice', 'data-content' => "<span class='label label-success'>Обработан</span>"}],
            ], member.status), {:class => 'selectpicker', 'data-width' => '150px'}),
        status: member.status,
        DT_RowId: 'member_' + member.id.to_s,
        DT_RowAttr: { 'data-id': member.id },
      }
    end
  end

  def members
    @members ||= fetch_members
  end

  def fetch_members
    members = Member.order("#{sort_column} #{sort_direction} NULLS LAST")
    members = members.where(is_friend: false)
    members = members.page(page).per_page(per_page)
    search_args = search_query
    if search_args
      members = members.where(search_args[:query], search_args[:params])
    end
    members
  end


  def sort_column
    columns = %w[
      vk_id
      concat_ws('\ ',first_name,last_name)
      last_seen_at
      last_seen_at
    ]
    columns[params[:iSortCol_0].to_i]
  end

end
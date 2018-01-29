class MembersDatatable
  delegate :params, :link_to, :select_tag, :options_for_select, :content_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Member.count,
      iTotalDisplayRecords: members.total_entries,
      aaData: data
    }
  end

  private

  def data
    members.map do |member|
      {
        vk_id: link_to(member.vk_id.to_s, 'https://vk.com/id' + member.vk_id.to_s),
        full_name: member.first_name.to_s + ' ' + member.last_name.to_s,
        last_seen_at: member.last_seen_at.nil? ? '' : member.last_seen_at,
        links:
          link_to(content_tag(:i, '', class: 'fa fa-info'), member, { class: 'btn btn-sm btn-outline-primary', role: 'button', title: 'Показать'}) +
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
    members = members.page(page).per_page(per_page)
    if params[:sSearch].present?
      members = members.where("first_name ilike :search or last_name ilike :search or screen_name ilike :search", search: "%#{params[:sSearch]}%")
    end
    members
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
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

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
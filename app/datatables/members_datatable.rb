class MembersDatatable
  delegate :params, :link_to, to: :@view

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
      [
        link_to(member.vk_id.to_s, 'https://vk.com/id' + member.vk_id.to_s),
        member.first_name.to_s + ' ' + member.last_name.to_s,
        member.last_seen_at.nil? ? '' : member.last_seen_at,
        link_to('Показать', member),
      ]
    end
  end

  def members
    @members ||= fetch_members
  end

  def fetch_members
    members = Member.order("#{sort_column} #{sort_direction} NULLS LAST")
    members = members.page(page).per_page(per_page)
    if params[:sSearch].present?
      members = members.where("first_name like :search or last_name like :search or vk_id like :search", search: "%#{params[:sSearch]}%")
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
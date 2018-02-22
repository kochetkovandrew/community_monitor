class CopyMessagesDatatable
  delegate :params, :link_to, :select_tag, :options_for_select, :content_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: CopyMessage.count,
      iTotalDisplayRecords: copy_messages.total_entries,
      aaData: data
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


  def data
    copy_messages.map do |copy_message|
      body = copy_message.body
      raw = JSON.parse(copy_message.raw)
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
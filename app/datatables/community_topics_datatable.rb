class CommunityTopicsDatatable < ApplicationDatatable
  delegate :link_to, :select_tag, :options_for_select, :content_tag, :entry_body, :t, to: :@view

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Topic.where(community_id: params[:id]).count,
      iTotalDisplayRecords: objects.total_entries,
      aaData: data
    }
  end

  private

  def search_keys
    {"(raw #>> '{text}')" => :string}
  end

  def data
    objects.map do |topic|
      {
        body: entry_body(topic),
        DT_RowAttr: { 'data-id': topic.id },
      }
    end
  end

  def fetch_query
    Topic.where(community_id: params[:id])
  end

  def sort_column
    columns = %w[
      created_at
    ]
    columns[params[:iSortCol_0].to_i]
  end

end
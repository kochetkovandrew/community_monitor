class CommunityTopicsDatatable < ApplicationDatatable
  delegate :link_to, :select_tag, :options_for_select, :content_tag, :entry_body, :t, to: :@view

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Topic.where(community_id: params[:id]).count,
      iTotalDisplayRecords: topics.total_entries,
      aaData: data
    }
  end

  private

  def search_keys
    {"(raw #>> '{text}')" => :string}
  end

  def data
    topics.map do |topic|
      {
        body: entry_body(topic),
        DT_RowAttr: { 'data-id': topic.id },
      }
    end
  end

  def topics
    @topics ||= fetch_topics
  end

  def fetch_topics
    topics = Topic.where(community_id: params[:id]).order("#{sort_column} #{sort_direction} NULLS LAST")
    topics = topics.page(page).per_page(per_page)
    search_args = search_query
    if search_args
      topics = topics.where(search_args[:query], search_args[:params])
    end
    topics
  end


  def sort_column
    columns = %w[
      created_at
    ]
    columns[params[:iSortCol_0].to_i]
  end

end
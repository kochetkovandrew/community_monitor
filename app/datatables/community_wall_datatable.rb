class CommunityWallDatatable < ApplicationDatatable
  delegate :link_to, :select_tag, :options_for_select, :content_tag, :entry_body, :t, to: :@view

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Post.where(community_id: params[:id]).count,
      iTotalDisplayRecords: objects.total_entries,
      aaData: data
    }
  end

  private

  def search_keys
    {"(raw #>> '{text}')" => :string}
  end

  def data
    objects.map do |post|
      {
        body: entry_body(post),
        DT_RowAttr: { 'data-id': post.id },
      }
    end
  end

  def fetch_query
    Post.where(community_id: params[:id])
  end

  def sort_column
    columns = %w[
      created_at
    ]
    columns[params[:iSortCol_0].to_i]
  end

end
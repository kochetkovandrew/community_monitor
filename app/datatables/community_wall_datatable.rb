class CommunityWallDatatable < ApplicationDatatable
  delegate :link_to, :select_tag, :options_for_select, :content_tag, :entry_body, :t, to: :@view

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Post.where(community_id: params[:id]).count,
      iTotalDisplayRecords: posts.total_entries,
      aaData: data
    }
  end

  private

  def search_keys
    {"(raw #>> '{body}')" => :string}
  end

  def data
    posts.map do |post|
      {
        body: entry_body(post),
        DT_RowAttr: { 'data-id': post.id },
      }
    end
  end

  def posts
    @posts ||= fetch_posts
  end

  def fetch_posts
    posts = Post.where(community_id: params[:id]).order("#{sort_column} #{sort_direction} NULLS LAST")
    posts = posts.page(page).per_page(per_page)
    search_args = search_query
    if search_args
      posts = posts.where(search_args[:query], search_args[:params])
    end
    posts
  end


  def sort_column
    columns = %w[
      created_at
    ]
    columns[params[:iSortCol_0].to_i]
  end

end
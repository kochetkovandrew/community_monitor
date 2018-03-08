class PostCommentsDatatable < ApplicationDatatable
  delegate :link_to, :select_tag, :options_for_select, :content_tag, :entry_body, :t, to: :@view

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: PostComment.where(post_id: params[:id]).count,
      iTotalDisplayRecords: post_comments.total_entries,
      aaData: data
    }
  end

  private

  def search_keys
    {"(raw #>> '{body}')" => :string}
  end

  def data
    post_comments.map do |post_comment|
      {
        body: entry_body(post_comment),
        DT_RowAttr: { 'data-id': post_comment.id },
      }
    end
  end

  def post_comments
    @post_comments ||= fetch_post_comments
  end

  def fetch_post_comments
    post_comments = PostComment.where(post_id: params[:id]).order("#{sort_column} #{sort_direction} NULLS LAST")
    post_comments = post_comments.page(page).per_page(per_page)
    search_args = search_query
    if search_args
      post_comments = post_comments.where(search_args[:query], search_args[:params])
    end
    post_comments
  end


  def sort_column
    columns = %w[
      created_at
    ]
    columns[params[:iSortCol_0].to_i]
  end

end
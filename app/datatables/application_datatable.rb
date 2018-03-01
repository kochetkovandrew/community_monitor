class ApplicationDatatable
  delegate :params, to: :@view

  def initialize(view)
    @view = view
  end

  protected

  def search_keys
    {}
  end

  def search_query
    if params[:sSearch].present?
      search_tokens = params[:sSearch].split(' ')
      search_params = {}
      subqueries = []
      search_tokens.each_with_index do |search_token, index|
        subquery = ''
        search_keys.each do |search_key, kind|
          if kind == :integer
            if search_token.match /^\d+$/
              if subquery != ''
                subquery += ' or '
              end
              subquery += (search_key + ' = ' + ':search' + index.to_s + 'i')
              search_params[('search' + index.to_s + 'i').to_sym] = search_token.to_i
            end
          else
            if subquery != ''
              subquery += ' or '
            end
            subquery += (search_key + ' ilike ' + ':search' + index.to_s + 't')
            search_params[('search' + index.to_s + 't').to_sym] = '%' + search_token + '%'
          end
        end
        subqueries.push('(' + subquery + ')')
      end
      { query: subqueries.join(' and '), params: search_params }
    else
      nil
    end
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end
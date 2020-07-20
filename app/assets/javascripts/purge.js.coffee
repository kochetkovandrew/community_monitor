jQuery ->
  $('#purge_mark_all').click ->
    $('input[type=checkbox]').prop('checked', true)
  $('#purge_unmark_all').click ->
    $('input[type=checkbox]').prop('checked', false)
  $('#purge_delete_comments').click ->
    arr = []
    $('input[type=checkbox]:checked').each ->
      arr.push { type: $(this).closest('tr').data('type'), source_id: $(this).closest('tr').data('source-id'), post_id: $(this).closest('tr').data('post-id') }
    $.ajax
      method: 'PATCH'
      url: '/purge'
      data: { posts: arr, access_key: $('input[name=access_key]').val() }

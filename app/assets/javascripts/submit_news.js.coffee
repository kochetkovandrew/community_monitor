jQuery ->
  $('select#submit_news_status').change ->
    submit_news_id = $(this).closest('tr').attr('data-id')
    status = $('option:selected', $(this)).val()
    $.ajax
      method: 'PUT'
      url: '/submit_news/' + submit_news_id + '.json'
      data: { submit_news: { status: status } }

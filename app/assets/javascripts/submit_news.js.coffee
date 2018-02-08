jQuery ->
  $('select#submit_news_status').change ->
    submit_news_id = $(this).closest('tr').attr('data-id')
    status = $('option:selected', $(this)).val()
    $.ajax
      method: 'PUT'
      url: '/submit_news/' + submit_news_id + '.json'
      data: { submit_news: { status: status } }
  $('#submit_news button.wrap').click ->
    tr = $(this).closest('tr')
    div = $('div.submit_news', tr)
    if div.hasClass('min_height')
      div.removeClass('min_height')
      $('i', $(this)).removeClass('fa-angle-double-down')
      $('i', $(this)).addClass('fa-angle-double-up')
    else
      div.addClass('min_height')
      $('i', $(this)).removeClass('fa-angle-double-up')
      $('i', $(this)).addClass('fa-angle-double-down')

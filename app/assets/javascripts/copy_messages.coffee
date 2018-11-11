# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

messagesGoPage = (page) ->
  if page > 0
    $('table#copy_messages').DataTable().page(page-1).draw('page')
    window.history.pushState("", "", $('input[name=basepath]').val() + "?page=" + page);


jQuery ->
  page = parseInt(getUrlVar('page'))
  if page
    displayStart = 25 * (parseInt(page) - 1)
  else
    displayStart = 0
  # $('select#archive_topic').select2()
  $('button.message_archive_topic_button').click () ->
    topic_id = parseInt($('select option:selected', $(this).parent()).val())
    topic_title = $('select option:selected', $(this).parent()).text()
    ids = $('.archive_checkbox:checked').map(->
      $(this).closest('tr').data 'id'
    ).get()
    if (topic_id > 0) && (ids.length > 0)
      $.ajax
        method: 'POST'
        url: '/copy_messages/archive.json'
        data: { topic_id: topic_id, ids: ids }
        success: (data) ->
          $.each ids, (index, id) ->
            $('input[type=checkbox]', 'tr[data-id=' + id + ']').remove()
            $('p.copy_message_topic', 'tr[data-id=' + id + ']').append($('<b></b>').text('Архив: ' + topic_title))
            $('tr[data-id=' + id + ']').data('topic-id', topic_id)
            $('tr[data-id=' + id + ']').data('topic-title', topic_title)
        beforeSend: () ->
          $('.modal').modal('show')
        complete: () ->
          $('.modal').modal('hide')
  $('table#copy_messages').dataTable
    iDisplayLength: 25
    lengthMenu: [25]
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#copy_messages').data('source')
    asStripeClasses: [ ]
    displayStart: displayStart
    columns: [
      { data: "body" },
    ]
    language:
      url: '/i18n/dataTables.russian.json'
    dom: '<"toolbar">frtip'
    fnDrawCallback: ->
      avatars = $('table#copy_messages').DataTable().ajax.json().avatars
      $('span.im-avatar').each ->
        user_vk_id = $(this).data('user-vk-id')
        if avatars[user_vk_id]
          console.log $(this).parent().parent().prop('nodeName')
          if $(this).parent().parent().prop('nodeName') != 'SPAN'
            if !$(this).closest('tr').data('topic-id')
              $(this).append $('<input type="checkbox">').addClass('archive_checkbox')
            else
              $('p.copy_message_topic', $(this).closest('tr')).first().append($('<b></b>').text('Архив: ' + $(this).closest('tr').data('topic-title')))
          $(this).append $('<img>', {src: avatars[user_vk_id].avatar})
          # $(this).append $('<br>')
      $('span.im-name').each ->
        user_vk_id = $(this).data('user-vk-id')
        if avatars[user_vk_id]
          $(this).append(avatars[user_vk_id].full_name)
      window.history.pushState("", "", $('input[name=basepath]').val() + "?page=" + ($('table#copy_messages').DataTable().page() + 1))
    initComplete: (settings, json) ->
      $("div.toolbar").append('<b>Перейти к странице:</b>')
      $("div.toolbar").append($('<input></input>').attr('name', 'datatables[page]'))
      $("input[name='datatables[page]']").keypress (e) ->
        if (e.which == 13)
          page = parseInt($(this).val())
          messagesGoPage(page)

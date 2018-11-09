# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

messagesGoPage = (page) ->
  if page > 0
    $('table#copy_messages').DataTable().page(page-1).draw('page')
    window.history.pushState("", "", "/copy_messages?page=" + page);


jQuery ->
  page = parseInt(getUrlVar('page'))
  if page
    displayStart = 25 * (parseInt(page) - 1)
  else
    displayStart = 0
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
          $(this).append $('<img>', {src: avatars[user_vk_id].avatar})
      $('span.im-name').each ->
        user_vk_id = $(this).data('user-vk-id')
        if avatars[user_vk_id]
          $(this).append(avatars[user_vk_id].full_name)
    initComplete: (settings, json) ->
      $("div.toolbar").append('<b>Перейти к странице:</b>')
      $("div.toolbar").append($('<input></input>').attr('name', 'datatables[page]'))
#      if page
#        messagesGoPage(page)
      $("input[name='datatables[page]']").keypress (e) ->
        if (e.which == 13)
          page = parseInt($(this).val())
          messagesGoPage(page)

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('table#copy_messages').dataTable
    iDisplayLength: 25
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#copy_messages').data('source')
    asStripeClasses: [ ]
    columns: [
      { data: "body" },
    ]
    language:
      url: '/i18n/dataTables.russian.json'
    fnDrawCallback: ->
      avatars = $('table#copy_messages').DataTable().ajax.json().avatars
      $('span.im-avatar').each ->
        user_vk_id = $(this).data('user-vk-id')
        if avatars[user_vk_id]
          $(this).append $('<img>', {src: avatars[user_vk_id].avatar})
          $(this).append $('<span>').text(avatars[user_vk_id].full_name)
        console.log user_vk_id
      console.log avatars
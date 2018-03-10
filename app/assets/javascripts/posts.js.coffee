jQuery ->
  $('table#post_comments').DataTable
    iDisplayLength: 25
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('table#post_comments').data('source')
    asStripeClasses: [ ]
    columns: [
      { data: "body" },
    ]
    order: [[ 0, "asc" ]]
    language:
      url: '/i18n/dataTables.russian.json'
    fnDrawCallback: ->
      avatars = $('table#post_comments').DataTable().ajax.json().avatars
      $('span.im-avatar').each ->
        user_vk_id = $(this).data('user-vk-id')
        if avatars[user_vk_id]
          $(this).append $('<img>', {src: avatars[user_vk_id].avatar})
      $('span.im-name').each ->
        user_vk_id = $(this).data('user-vk-id')
        if avatars[user_vk_id]
          $(this).append(avatars[user_vk_id].full_name)

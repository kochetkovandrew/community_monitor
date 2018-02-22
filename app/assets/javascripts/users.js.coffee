jQuery ->
  $('table#permission_user input:checkbox').change ->
    user_id = $(this).data('user-id')
    permission_id = $(this).data('permission-id')
    if $(this).prop('checked')
      $.ajax
        method: 'PUT'
        dataType: 'json'
        url: '/users/' + user_id + '/assign_permission'
        data: { permission_id: permission_id }
    else
      $.ajax
        method: 'PUT'
        dataType: 'json'
        url: '/users/' + user_id + '/revoke_permission'
        data: { permission_id: permission_id }

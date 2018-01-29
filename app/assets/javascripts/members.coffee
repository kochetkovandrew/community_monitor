# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('table#listing_members').dataTable
    iDisplayLength: 25
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#listing_members').data('source')
    columns: [
      { data: "vk_id" },
      { data: "full_name" },
      { data: "last_seen_at" },
      { data: "links" }
    ]
    fnDrawCallback: ->
      $('.selectpicker').selectpicker()
      $('select#member_status').change ->
        member_id = $(this).closest('tr').attr('data-id')
        status = $('option:selected', $(this)).val()
        $.ajax
          method: 'PUT'
          url: '/members/' + member_id + '.json'
          data: { member: { status: status } }
  $('table.friends_info').dataTable()
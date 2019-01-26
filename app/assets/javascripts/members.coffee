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
      { data: "city_title" },
      { data: "last_seen_at" },
      { data: "links" }
    ]
    aoColumnDefs: [
      { sWidth: '50px', sClass: "listing_members_vk_id_td", aTargets: [ 0 ] }
    ]
    language:
      url: '/i18n/dataTables.russian.json'
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
  $('.table-member-info .tr-hidable').hide()
  $('.table-member-info .hide-info').hide()
  $('.table-member-info .hide-info').click ->
    $('.table-member-info .tr-hidable').hide()
    $('.table-member-info .hide-info').hide()
    $('.table-member-info .show-info').show()
  $('.table-member-info .show-info').click ->
    $('.table-member-info .tr-hidable').show()
    $('.table-member-info .show-info').hide()
    $('.table-member-info .hide-info').show()

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('table#listing_members').dataTable
    iDisplayLength: 25
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#listing_members').data('source')
  $('table.friends_info').dataTable()

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('table#listing_communities').DataTable
    language:
      url: '/i18n/dataTables.russian.json'
  $('table#community_wall').DataTable
    iDisplayLength: 25
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('table#community_wall').data('source')
    asStripeClasses: [ ]
    columns: [
      { data: "body" },
    ]
    order: [[ 0, "desc" ]]
    language:
      url: '/i18n/dataTables.russian.json'

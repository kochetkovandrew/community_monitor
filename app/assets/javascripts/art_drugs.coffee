# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('#art_drugs').DataTable
    language:
      url: '/i18n/dataTables.russian.json'

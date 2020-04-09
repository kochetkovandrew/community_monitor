# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#file_upload').change () ->
    files = $(this)[0].files
    names = []
    if files && (files.length > 1)
      $.each files, (index, file) ->
        names.push file['name']
    if names.length > 1
      $('#file_list').text 'Выбраны файлы: ' + names.join(', ')
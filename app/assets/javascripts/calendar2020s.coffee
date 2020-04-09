# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


selectCalendar2020 = (date) ->
  links = JSON.parse($('#links').val())
  if links[date]
    console.log links[date]
    win = window.open(links[date], '_blank')
    win.focus()
  else
    console.log 'xxx'

jQuery ->
  $('#calendar2020_day').datepicker
    onSelect: (date, datepicker) ->
      selectCalendar2020(date)
    dateFormat: 'yy-mm-dd'
    $.datepicker.regional["ru"]

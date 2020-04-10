# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


selectCalendar2020 = (date) ->
  links = JSON.parse($('#links').val())
  link_to_edit = $('<a></a>')
  link_to_edit.attr('href', '/calendar2020s/' + date + '/edit')
  link_to_edit.text('Редактировать')
  $('#link_to_edit').text('')
  $('#link_to_edit').append(link_to_edit)
  if links[date]
    $('#calendar2020_text').text('')
    if links[date]['header'] != ''
      h4 = $('<h4></h4>').text(links[date]['header'])
      $('#calendar2020_text').append(h4)
    div_main = $('<div class="main_text"></div>')
    div_main.append(links[date]['text'])
    div_outer = $('<div class="text_outer"></div>')
    div_outer.append(div_main)
    $('#calendar2020_text').append(div_outer)
    if links[date]['has_picture']
      img = $('<img src="/images/calendar/' + date + '.jpg">"')
      $('#calendar2020_pic').text('')
      $('#calendar2020_pic').append(img)
  else
    $('#calendar2020_text').text('')
    $('#calendar2020_pic').text('')
    h4 = $('<h4></h4>').text('–')
    $('#calendar2020_text').append(h4)
    div_main = $('<div class="main_text"></div>')
    div_main.append('В этот день ничего не случилось')
    $('#calendar2020_text').append(div_main)

initCalendar = () ->
  dd = new Date()
  dd.setDate(dd.getDate() - 1)
  $('#calendar2020_day').datepicker
    minDate: new Date('2020-01-01')
    yearRange: '2020:2020'
    defaultDate: dd
    onSelect: (date, datepicker) ->
      selectCalendar2020(date)
    dateFormat: 'yy-mm-dd'
    $.datepicker.regional["ru"]
  if $('#calendar2020_day').length > 0
    selectCalendar2020(dd.toISOString().slice(0, 10))


jQuery ->
  initCalendar()
  $('#uploadbtn').change (e) ->
    $.each e.target.files, (index, file) ->
      span = $('<span class="filespan"></span>')
      span.text(file.name)
      $('div#filenames').append(span)

#  $('#calendar2020_day').datepicker
#    onSelect: (date, datepicker) ->
#      selectCalendar2020(date)
#    dateFormat: 'yy-mm-dd'
#    $.datepicker.regional["ru"]

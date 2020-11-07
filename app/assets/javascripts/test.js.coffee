jQuery ->
  $('#planet_start').click () ->
    i = 0
    t = parseInt($('#temperature').val())
    irrad = $('#irradiation').val()
    while i < 300
      t += (irrad / 100)
      i++
      t -= (t*t*t*t*0.000000001)
      console.log t
    $('#temperature').val(t)
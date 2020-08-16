# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

check3 = () ->
  if $("input[name='umfrage[frage3]']:checked").val() == "Ja"
    $("#li4").show()
    $("#li5").show()
  else
    $("#li4").hide()
    $("#li5").hide()


check6 = () ->
  if $("input[name='umfrage[frage6]']:checked").val() == "Ja"
    $("#li7").show()
  else
    $("#li7").hide()

jQuery ->
  check3()
  check6()
  $("input[name='umfrage[frage3]']").change ->
    check3()
  $("input[name='umfrage[frage6]']").change ->
    check6()

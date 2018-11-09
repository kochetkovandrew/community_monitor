// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
// require jquery.turbolinks
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap-select
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.api.fnReloadAjax
// require jquery.ui.all
//= require jquery-ui
//= require select2
// require turbolinks

//= require_tree .

// getUrlVar = (key) ->
//   result = new RegExp(key + '=([^&]*)', 'i').exec(window.location.search)
//   result && decodeURIComponent(result[1]) || ''

function getUrlVar(key){
  var result = new RegExp(key + "=([^&]*)", "i").exec($(location).attr('href'));
  return result && decodeURIComponent(result[1]) || "";
}

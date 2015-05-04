// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/autocomplete
//= require jquery-ui/core
//= require jquery-ui/widget
//= require jquery-ui/mouse
//= require jquery-ui/position
//= require jquery-ui/dialog
//= require jquery-ui/spinner
//= require turbolinks
//= require foundation
//= require hide_toggler
//= require common_tools
//= require common_tools/jquery-spin
//= require mousetrap.min
//= require jquery.dataTables.min
//require dataTables.tableTools
//= require humane.min
//= require_tree .

function init_foundation() {
  $(document).foundation();
  $(function(){ $(document).foundation(); });
  $(document).foundation('reveal', {animation_speed: 75});
  $(".full-height").height($(".main").parent().height()); 
  $('.inner-wrap').height($(".main").parent().height()); 
}

function unbind_all_keyboard_listeners() {
  $(document).unbind('keyup');
}

function bind_short_cut_for_toggler() {
  if ($('div.toggler_parent').length) {
    Mousetrap.bind('alt+k', function(e) {
      $('.toggler_parent a').click();
    });
  }
}

//============================
// START Logic when page is loaded
//============================

init_foundation();

$(document).ready(function(){
  $('a.close-reveal-modal').remove();
  bind_short_cut_for_toggler();

  //Logic for tabindexes --START
  $(".toggler_parent a").attr("tabindex", -1);
  //Logic for tabindexes --START

});
//============================
// END Logic when page is loaded
//============================



//============================
// START Tourbolinks Configuration
//============================
Turbolinks.enableProgressBar();
$(document).on('page:load', init_foundation);
$(document).on('page:load', bind_short_cut_for_toggler);

//Use page:receive so that unbinding keyboard events happens before
//the page has been parsed. Using page:load remove any keyboard bindings
//because it is triggered at the end of the loading process.
$(document).on('page:receive', unbind_all_keyboard_listeners);
$(document).on('page:receive', function(){ Mousetrap.reset() });
//============================
// END Tourbolinks Configuration
//============================



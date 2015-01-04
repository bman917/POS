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
//= require jquery-ui/core
//= require jquery-ui/widget
//= require jquery-ui/mouse
//= require jquery-ui/position
//= require turbolinks
//= require foundation
//= require foundation/foundation.accordion
//= require hide_toggler
//= require common_tools
//= require_tree .

function init_foundation() {
  $(document).foundation();
  $(function(){ $(document).foundation(); });
  $(document).foundation('reveal', {animation_speed: 75});
}

function unbind_all_keyboard_listeners() {
  $(document).unbind('keyup');
}

init_foundation();

$(document).ready(function(){
  $('a.close-reveal-modal').remove();
});

//Tourbolinks Configuration
Turbolinks.enableProgressBar();
$(document).on('page:load', init_foundation);
$(document).on('page:load', unbind_all_keyboard_listeners);
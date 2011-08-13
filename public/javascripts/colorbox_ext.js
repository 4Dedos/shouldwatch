// Colorbox
$(document).ready(function(){
  if ($('.first_visit_popup').size() > 0) {
    $.colorbox({href:"/home/first_visit", opacity:'0.55'});
  }
  if ($('.welcome_guest_popup').size() > 0) {
    $.colorbox({href:"/home/welcome_guest", opacity:'0.55'});
  }
});

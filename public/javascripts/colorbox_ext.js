// Colorbox

$(document).ready(function(){
  
  if ($('#popup').size() > 0) {
    $.colorbox({html: $('#popup').html() , open:true, opacity:'0.55', height: '33%', onClosed: popupClose });
  }   
  
});

// Colorbox

$(document).ready(function(){
  
  if ($('#popup').size() > 0) {
    var content = $('#popup').html();
    if ($('#popup .popup_content').size() > 0) {
      var content = $('#popup .popup_content').html();
    } 
    
    var onClosedCallback = eval($('#popup .callbacks').attr('onClosed'));

    $.colorbox({html: content, open:true, opacity:'0.55', height: '33%', onClosed: onClosedCallback });
  }   
  
});

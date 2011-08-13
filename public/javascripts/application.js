MovieSearch = {
  initialize: function(){
    $(function() {
      $('#search_handle').click(function(){
        $('#search_box').show();
      });
		  $( "#search_field" ).autocomplete({
			  source: "/movies/search",
        appendTo: "#search_results",
			  minLength: 1,
			  select: function( event, ui ) {
          $('#search_box form').submit();
				  console.log( ui.item ?
					  "Selected: " + ui.item.value + " aka " + ui.item.id :
					  "Nothing selected, input was " + this.value );
			  }
		  });
	  });
  }
};

// Popups Callbacks functions
var callback_on_recommendation_close = function() {}

//Uniforms
	$(function(){
		$("input, textarea, select, button").uniform();
	});

// Colorbox
$(document).ready(function(){
  
  $(".colorbox-link").colorbox();
	
  $(".header .menu li").click(function(){
    $(".header .menu li.selected").removeClass('selected');
    $(this).addClass('selected');
  })
  
});


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
          $('#search_box').hide();
          $('#rt_id').val(ui.item.id);
          $('#search_box form').submit();
			  }
		  })
      .data( "autocomplete" )._renderItem = function( ul, item ) {
        return $( "<li></li>" )
          .data( "item.autocomplete", item )
          .append( $("#autocomplete_template").tmpl(item) )
          .appendTo( ul );
      };
	  });
  }
};

// Popups Callbacks functions
function callback_on_recommendation_close() {}

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
  });
});


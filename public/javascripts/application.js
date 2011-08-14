MovieSearch = {
  initialize: function(){
    $(function() {
      $('#search_handle').click(function(){
        MovieSearch.showBox();
      });
      $('#search_field').blur(function(){
        MovieSearch.hideBox();
      });
		  $( "#search_field" ).autocomplete({
			  source: "/movies/search",
        appendTo: "#search_results",
			  minLength: 1,
        focus: function (event, ui) {
          $("#search_field").val(ui.item.title);
          return false;
        },
        select: function( event, ui ) {
          $('#search_box').hide();
          $('#rt_id').val(ui.item.id);
          $('#search_box form').submit();
          $("#search_field").val('');
          return false;
			  }
		  })
      .data( "autocomplete" )._renderItem = function( ul, item ) {
        return $( "<li></li>" )
          .data( "item.autocomplete", item )
          .append( $("#autocomplete_template").tmpl(item) )
          .appendTo( ul );
      };
	  });
  },
  showBox: function(){
    //$('#search_handle').hide();
    $('#search_box').slideDown();
    $('#search_field').focus();
  },
  hideBox: function(){
    $('#search_box').slideUp();
    //$('#search_handle').show();
  }
};

WatchList = {
  sortable: function () {
      $("#movies_i_want_to_watch").sortable({
        cursor: "move",
        update: function() {
          var movies_order = $(this).sortable('toArray').toString();
          $.post('/movies/order', {movies_order: movies_order});
        }
      });
  }
};

// Popups Callbacks functions
function callback_on_recommendation_close() {}

//Uniforms
$(function(){
	$("input, textarea, select, button").uniform();
});

function initialBind(){
  // Colorbox
  $(".colorbox-link").colorbox({opacity:'0.55', height: '500px'});
  WatchList.sortable();
}

function scrollToSection(sectionId) {
  $('body').attr('scrollingToSection', true);
  $.scrollTo(sectionId, 800, {duration:3000, onAfter: function(){
    $('body').removeAttr('scrollingToSection');
  }});
}

$(document).ready(function(){

  initialBind();

  var win = $(window);
  var sections = [$('#wantToWatchSection'),$('#recommendSection'),$('#recommendedSection')];

  $(".header .menu li").click(function(){
    $(".header .menu li.selected").removeClass('selected');
    $(this).addClass('selected');
  });


  win.scroll(function(){

    if ($('body').attr('scrollingToSection') === undefined) {

      var docViewTop = win.scrollTop(),
          docViewBottom = docViewTop + win.height(),
          header = 200;

      $.each(sections, function(index, elem) {
        var elemTop = elem.offset().top,
            elemBottom = elem.offset().top + elem.height();

        if ((elemTop >= docViewTop) && ((docViewBottom - elemTop) > ((win.height() / 2) + header ))) {
          $(".header .menu li.selected").removeClass('selected');
          $('li#' + elem.attr('id') + '_li').addClass('selected');
        }
      });
    }

  });



});


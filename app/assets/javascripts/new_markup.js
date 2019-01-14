var my_images = [
'/assets/button_tooltip_border.png',
'/assets/login_button_selected_bg.png',
'/assets/tooltip_cloud.png',
'/assets/call_button_bg.png'
];


$(document).mouseup(function (e)
{
    var container = $("#new_question");
    var question_body = $("#question_body").val();
    if (container.has(e.target).length === 0)
    {
      if(question_body == 0 || question_body == "")
      {
        $("#question_state").hide('slow');
        $("#question_area").hide('slow');
      }
    }
});

$(document).ready(function(){
  
  $('.testimonials_slider').bxSlider();
  
  if($(window).height() > 779){
    //Makes the filters sticky to top of page when page scrolls down
  	var msie6 = $.browser == 'msie' && $.browser.version < 7;
  	search_box = document.getElementById('filters');
  	if (search_box && !msie6) {
  		var top = $('#filters').offset().top + 40 - parseFloat($('#filters').css('margin-top').replace(/auto/, 0));
  		$(window).scroll(function (event) {
  		  var y = $(this).scrollTop();
  		  if (y >= top) {
  			$('#filters').addClass('fixed');
  			//$('.slidey').addClass('nudge');
  		  } else {
  			$('#filters').removeClass('fixed');
  			//$('.slidey').removeClass('nudge');
  		  }
  		});
  	}
  }
  
  //Makes the question box sticky to top of page when page scrolls down
	var msie6 = $.browser == 'msie' && $.browser.version < 7;
	search_box = document.getElementById('generail_question');
	filters = document.getElementById('filters');
	if (search_box && filters && !msie6) {
		var top = $('#generail_question').offset().top - parseFloat($('#filters').css('margin-top').replace(/auto/, 0));
		$(window).scroll(function (event) {
		  var y = $(this).scrollTop();
		  if (y >= top) {
			$('#generail_question').addClass('fixed_question');
			$('#service_type_tabs').addClass('fixed_question_margin');
			//$('.slidey').addClass('nudge');
		  } else {
			$('#generail_question').removeClass('fixed_question');
			$('#service_type_tabs').removeClass('fixed_question_margin');
			//$('.slidey').removeClass('nudge');
		  }
		});
	}
  
  /*$(function() {
      var search_box = document.getElementById('filters');
      if(search_box){
        var $sidebar = $('#filters');
        var $wrapper = $('#inline-wrapper > .main_content');
        var t = undefined;
        $sidebar.data('my_offsets', {
            min: $sidebar.offset().top,
            max: ($wrapper.offset().top + $wrapper.height() - $sidebar.height()),
            start: $(window).scrollTop()
        });
        var handler = function(e) {
            var offsets = $sidebar.data('my_offsets');
            var scroll_direction = (offsets.start < $(window).scrollTop()) ? 1 : -1;
            $sidebar.data('my_offsets').start = $(window).scrollTop();
            var slide_to = undefined;

            var sidebar_top = Math.round($sidebar.offset().top);
            var sidebar_bottom = Math.round(sidebar_top + $sidebar.height());

            var window_top = $(window).scrollTop();
            var window_bottom = window_top + $(window).height();

            if (scroll_direction > 0) {
                if (sidebar_bottom < window_bottom) {
                    slide_to = window_bottom - $sidebar.height();
                }
            } else {
                if (sidebar_top > window_top) {
                    slide_to = window_top;
                }
            }

            if (slide_to != undefined) {
                if (slide_to > offsets.max) {
                    slide_to = offsets.max;
                } else if (slide_to < offsets.min) {
                    slide_to = offsets.min;
                }

                clearTimeout(t);
                t = setTimeout(function() {
                    $sidebar.animate({"top": slide_to}, "fast");
                }, 50);
            }
        }

        $(window).bind('scroll', handler);
        $(window).trigger('scroll');
    }
  });*/
  $(".profile_info .client-reviews .review").first().addClass('first');
  $(".profile_info .client-reviews .review").last().addClass('last');
  
	$(my_images).each(function() { 	
		var image = $('<img />').attr('src', this).hide();
		$('body').append(image);
		image.remove();
	});
	$('.avatar img, .image-carousel img').each(function(){
		var imgsrc = $(this).attr('src');
		var imgcheck = imgsrc.width;


		$(this).live("error", function() {
		  $(this).attr('src', '/assets/profile_m.gif');
		});
	});
		
	$(".left-bar-section span.voice.online, .left-bar-section span.online_voice_tooltip").live('mouseover', function(){
	  $(".voice_chat.tooltip.online").fadeIn('slow');
	});
	$(".left-bar-section span.voice.online, .left-bar-section span.online_voice_tooltip").live('mouseout', function(){
	  $(".voice_chat.tooltip.online").fadeOut('slow');
	});
	
	
	$(".left-bar-section span.voice.offline, .left-bar-section span.offline_voice_tooltip").live('mouseover', function(){
	  $(".voice_chat.tooltip.offline").fadeIn('slow');
	});
	$(".left-bar-section span.voice.offline, .left-bar-section span.offline_voice_tooltip").live('mouseout', function(){
	  $(".voice_chat.tooltip.offline").fadeOut('slow');
	});
	
	
	$(".left-bar-section span.video.offline, .left-bar-section span.offline_video_tooltip").live('mouseover', function(){
	  $(".video_chat.tooltip.offline").fadeIn('slow');
	});
	$(".left-bar-section span.video.offline, .left-bar-section span.offline_video_tooltip").live('mouseout', function(){
	  $(".video_chat.tooltip.offline").fadeOut('slow');
	});
	
	
	$(".left-bar-section span.video.online, .left-bar-section span.online_video_tooltip").live('mouseover', function(){
	  $(".video_chat.tooltip.online").fadeIn('slow');
	});
	$(".left-bar-section span.video.online, .left-bar-section span.online_video_tooltip").live('mouseout', function(){
	  $(".video_chat.tooltip.online").fadeOut('slow');
	});
	
	
	$("input[name='practice_area']").imageTick({
		tick_image_path: "/assets/radio_selected.png",
		no_tick_image_path: "/assets/radio.png",
		image_tick_class: "radios"
	});   	
	$("span.video.online").live('mouseover', function(){
	  $(this).nextAll(".video_chat.tooltip.online").not('.dominant').fadeIn('slow');
	});
	$("span.video.online").live('mouseout', function(){
	  $(this).nextAll(".video_chat.tooltip.online").not('.dominant').fadeOut('slow');
	});
	$("span.voice.online").live('mouseover', function(){
	  $(this).nextAll(".voice_chat.tooltip.online").not('.dominant').fadeIn('slow');
	});
	$("span.voice.online").live('mouseout', function(){
	  $(this).nextAll(".voice_chat.tooltip.online").not('.dominant').fadeOut('slow');
	});
	
  $("div.row.lawyer").live('mouseover', function(){
    $(this).find(".tooltip.dominant").show();
  });

  $("div.row.lawyer").live('mouseout', function(){
    $(this).find(".tooltip.dominant").hide();
  });

	$("span.text.online").live('mouseover', function(){
	  $(this).nextAll(".text_chat.tooltip.online").not('.dominant').fadeIn('slow');
	});
	$("span.text.online").live('mouseout', function(){
	  $(this).nextAll(".text_chat.tooltip.online").not('.dominant').fadeOut('slow');
	});	
	$("span.text.offline").live('mouseover', function(){
	  $(this).nextAll(".text_chat.tooltip.offline").not('.dominant').fadeIn('slow');
	});
	$("span.text.offline").live('mouseout', function(){
	  $(this).nextAll(".text_chat.tooltip.offline").not('.dominant').fadeOut('slow');
	});
	
	$("span.note").live('mouseover', function(){
	  $(this).nextAll(".note_chat.tooltip").not('.dominant').fadeIn('slow');
	});
	$("span.video.offline").live('mouseover', function(){
	  $(this).nextAll(".video_chat.tooltip.offline").not('.dominant').fadeIn('slow');
	});
	$("span.video.offline").live('mouseout', function(){
	  $(this).nextAll(".video_chat.tooltip.offline").not('.dominant').fadeOut('slow');
	});
	$("span.voice.offline").live('mouseover', function(){
	  $(this).nextAll(".voice_chat.tooltip.offline").not('.dominant').fadeIn('slow');
	});
	$("span.voice.offline").live('mouseout', function(){
	  $(this).nextAll(".voice_chat.tooltip.offline").not('.dominant').fadeOut('slow');
	});  	
  $("span.note").live('mouseout', function(){
	  $(this).nextAll(".note_chat.tooltip").not('.dominant').fadeOut('slow');
	});
	var show_on_mouseenter = false;
	$('html').click(function() {
    $(".button_tooltip").hide();
    show_on_mouseenter = false;
  });
  
  $("#question_body").focus(function(event){
    event.stopPropagation();
    $("#question_state").show('slow');
    $("#question_area").show('slow');
  });
    
	$(".free_dropdown").live('click', function(event){
	  event.stopPropagation();
		$(".button_tooltip").hide();
    $(this).nextAll(".button_tooltip").show();
    show_on_mouseenter = true;
    //console.log(show_on_mouseenter);
	});
	  
  $(".free").live('mouseenter', function(){
    //console.log("111");
    $(this).data('hover',1);
    $(this).nextAll(".button_tooltip").show();
   //console.log(show_on_mouseenter);
  });
  $(".free").live('mouseleave', function(){ 	 
    $(this).data('hover',0);
    var self = this;
    var som = show_on_mouseenter;
    //console.log(show_on_mouseenter);
    var t = $(self).nextAll(".button_tooltip");
 	  setTimeout(function(){
 	    if(!(t.data('hover') || $(self).data('hover')) && !som){
 	      //console.log(som);
 	      t.hide();
 	    }
 	  }, 300);
  });
  $(".free").live('click', function(){ 	  	
     $(".button_tooltip").hide(); 	  	
     $(this).nextAll(".button_tooltip").show();
  });
  $(".button_tooltip").live('mouseenter', function() {
	    if(show_on_mouseenter == false){
	      $(this).data('hover',1);
	      //console.log('flag true');
	    }
	});
	$(".button_tooltip").live('mouseleave', function() {
	    if(show_on_mouseenter == false){
	      $(this).hide(); 
	      $(this).data('hover',0);
	      //console.log('flag false');
	    }
	});
	$( "#slider-range-min" ).slider({
	  range: "min",
    value: 37,
    min: 1,
    max: 700,
    slide: function( event, ui ) {
      $( "#amount" ).val( "$" + ui.value );
  }
  });
  $( "#free_minutes_slider" ).slider({
    range: "min",
    value: 1,
    min: 1,
    max: 8,
    slide: function( event, ui ) {
      $( "#minutes" ).val( "$" + ui.value );
    }
  });
  $( "#minutes" ).val( "$" + $( "#free_minutes_slider" ).slider( "value" ) );
  
  $( "#minimum_client_rating" ).slider({
    range: "min",
    value: 2,
    min: 1,
    max: 5,
    slide: function( event, ui ) {
      $( "#client_rating" ).val( "$" + ui.value );
    }
  });
  $( "#client_rating" ).val( "$" + $( "#minimum_client_rating" ).slider( "value" ) );
  
  $( "#hourly_rate" ).slider({
    range: true,
    values: [ 1, 4 ],
    min: 1,
    max: 4,
    slide: function( event, ui ) {
      $( "#hourly_rate_in" ).val( "$" + ui.value );
    }
  });
  $( "#hourly_rate_in" ).val( "$" + $( "#hourly_rate" ).slider( "value" ) );   
  
  $( "#law_school_quality" ).slider({
    range: "min",
    value: 2,
    min: 1,
    max: 4,
    slide: function( event, ui ) {
      $( "#law_school" ).val( "$" + ui.value );
    }
  });
  $( "#law_school" ).val( "$" + $( "#law_school_quality" ).slider( "value" ) );  

	var $video = $('body.attorneys.show .main_content .profile_info .main-content .video-block');
  var $info = $('body.attorneys.show .main_content .profile_info .main-content .main-info');
});

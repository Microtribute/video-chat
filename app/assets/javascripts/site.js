 $('#outer_div').css({"border":"solid #000 2px","padding":"2px"});
 var messageString = "";
 var isOverlayOpen = false;
//functions to bring up and collapse the video chat screen for lawyer
function CloseCall()
{
    closecall();
}
function equalHeight(group) {
    tallest = 0;
    group.each(function() {
       thisHeight = $(this).height();
       if(thisHeight > tallest) {
          tallest = thisHeight;
       }
    });
    group.height(tallest);
  }
  $(document).ready(function() {
    $('.row').each(function(){
      equalHeight($(this).find(".row_block"));
    });
    equalHeight($('.profile').find(".same_height"));
  });
function notifyUser(msg)
{
  if(!msg.search("ErrorMessage")){
    $.prompt(msg)
  }
}

function showFlash()
{
  // Centering video chat box wrapper
  $('#outer_div').css({
    "position": "absolute",
    "top": "62px",
    "left": "50%",
    "width": "960px",
    "height": "800px",
      "margin-left": "-480px"
  });
  //$('.mainc').css("display","none");
}

function updateFlash()
{
   var movie = swfobject.getObjectById('mySwf');
   movie.startPaidSession();
}

function cancelPaidSession()
{
  var movie = swfobject.getObjectById('mySwf');
  movie.cancelPaidSession();
}


function openPaymentDialog(username, caller)
{
  formatMessage(caller, username);
  $('.dialog-window').show();
  $('#dialog-overlay').show();
  var close = $('<div class="dialog-close"></div>');
  close.click( postponePayment );
  $('.dialog-window').append( close );
}

function postponePayment()
{
  close_dialogs();
  cancelPaidSession();
}

function formatMessage(caller,username)
{
  if(parseInt(caller) == 1)
  {
    messageString = "To start a paid session, you will need to have payment information on file";
  }
  else
  {
      messageString = "Attorney "+ username + " is requesting a paid session. To confirm this, you will need to have payment info on file";
  }
  $('.paid_model_header').html(messageString);
  isOverlayOpen = true;
}

function closecall()
{
      $('#outer_div').css({"left":"-2000px"});
      //$('.maic').css("display","block");
}
/*----------------------------------------*/

function select_unselect_state(id) {
 if ($('#state_' + id).is(":checked")) {
   $('#lawyer_bar_memberships_attributes_' + id + '_state_id').val($('#state_' + id).val());
 }
 // else {
// alert(id);
 //   $('#lawyer_bar_memberships_attributes_' + id + '_state_id').val('');
 //   $('#lawyer_bar_memberships_attributes_' + id + '_bar_id').val('');
 // }

}


function setBarIds(){
  var states_barids = new Array();
  var form_data_status = false;
  $('#leveled_list_bar_ids').children().each(function(index){
    var self = $(this);
    var checked = false;
    var chkbox = self.find('input[type=checkbox]')

    if (chkbox.attr('checked') == 'checked')
    {
        var dv = self.find('div');
        var state = dv.attr('id');
        var inp = dv.find('input');
        barId = inp.attr('value');
        if (barId == "")
        {
          //alert("please enter barid for the selected state " + state);
          //form_data_status = false;
          states_barids[state] = barId;
          form_data_status = true;
        }
        else
        {
          states_barids[state] = barId;
          form_data_status = true;
        }
    }
  });
  if(form_data_status)
  {
    var states_barids_string = "";
    for(key in states_barids)
    {
      states_barids_key_label = states_barids[key] ? "(Bar ID: " + states_barids[key] + ")" : '';

      if(states_barids_key_label) {
        states_barids_string += "" + key + " " + states_barids_key_label + ", ";
      } else {
        states_barids_string += "" + key + ", ";
      }
    }
    states_barids_string = states_barids_string.substring(0,states_barids_string.length-2) + "";
    $('#barids_opener').hide();
    $('#barids_editor').show().css({'display': 'inline', 'margin-left': '0.5em'});
    $('#div_states_barids').html(states_barids_string);
    $('#div_states_barids').show().css('display', 'inline');
    close_dialogs();
  }
  else
  {
    close_dialogs();
    return;
  }
}

function setPracticeAreas()
{
  var practice_area_string = "";
  var specialities_string = "";
  $('#leveled-list_practice_areas').children().each(function(index){
    var parent_list = $(this);
    var parent_checkbox = parent_list.find('input[type=checkbox]');
    //alert(parent_checkbox);
    if(parent_checkbox.attr('checked') == 'checked')
    {
      var for_alert = parent_checkbox.data('name');
      //alert(for_alert);
      practice_area_string += "" + parent_checkbox.data('name');
      //alert(practice_area_string);
      var div = parent_list.find('div');
      var inner_ul = div.find('ul');
      specialities_string = "";
      inner_ul.children().each(function(index){
        var inner_list = $(this);
        var chkbox = inner_list.find('input[type=checkbox]')
        if(chkbox.attr('checked') == 'checked')
        {
          specialities_string += chkbox.data('name') + ', '
        }
      });
      if(specialities_string != "")
      {
        specialities_string = specialities_string.substring(0,specialities_string.length - 2);
        practice_area_string += ' (' + specialities_string + ')'  + ', ';
      }
    }
  });
  practice_area_string = practice_area_string.substring(0,practice_area_string.length -2) + "";
  $('#practice_areas_opener').hide();
  $('#div_practice_areas').html(practice_area_string);
  $('#div_practice_areas').show().css('display', 'inline');
  $('#practice_areas_editor').show().css({'display': 'inline', 'margin-left': '0.5em'});
  close_dialogs();
}

function close_dialogs(){
    $('.dialog-window').hide();
    $('#dialog-overlay').hide();
}
$(document).ready(function() {
  $('.dialog-close').click( function(){ close_dialogs() });
  $(function(){

    $.fn.carousel = function(){
        if( this==null || this=='undefined' || this.length<=0 ) return;

        var self = this;
        self.current_image = 0;
        self.interv = setTimeout( next_image, 7000 );
        self.images = [];
        $.ajax( self.attr('dataurl'), {
            data:{'p':self.current_image++},
            dataType:'json',
            success:function( data, stat, ob ){ self.images = data; }
        });

        function goto_image( i ){
            clearTimeout(self.interv);
            self.current_image = i;
            var carousel_info =  self.images[self.current_image];
            var carousel_image = self.find('.carousel-image');
            carousel_image.find('img').attr('src', carousel_info['url']);
						carousel_image.find('a.profile_link').attr('href', carousel_info['href']);
            carousel_image.find('img').attr('alt', carousel_info['title']);
            self.find('.carousel-description .free').attr('href', carousel_info['free'] );
            self.find('.carousel-description h4').html( carousel_info['title'] );
            self.find('.carousel-description p.desc').html( carousel_info['description'] );
            self.find('.carousel-description p.rate').html( carousel_info['rate'] );
            self.find('.carousel-description p.small').html( carousel_info['small'] );
            self.find('.carousel-description .stars').html( carousel_info['rating'] );
            self.find('.carousel-description span.note').html( carousel_info['start_or_schedule_button_text_profile'] );
            /*self.find('.carousel-description p.active_action').html( carousel_info['active_action'] );

            if (carousel_info["active_action"] !== undefined) {
			      	  self.find('.carousel-description p.active_action')
										.html(carousel_info["active_action"])
									  .show();
		      	} else {
		      	  	self.find('.carousel-description p.active_action').html('').hide();
						}
            */

        		if (carousel_info["start_or_video_button_p"] !== undefined) {
						  self.find('.carousel-description span.video')
						    .addClass("online").removeClass("offline")
								.html(carousel_info["start_or_video_button_p"]);
						} else {
							  self.find('.carousel-description span.video').html('').addClass("offline").removeClass("online");
						}

						if (carousel_info["schedule_consultation"] !== undefined) {
						  self.find('.carousel-description span.text')
						    .addClass("online").removeClass("offline")
								.html(carousel_info["schedule_consultation"]);
						} else {
							  self.find('.carousel-description span.text').html('').addClass("offline").removeClass("online");
						}


						if (carousel_info["start_phone_consultation_p"] !== undefined) {
						  self.find('.carousel-description span.voice')
						    .addClass("online").removeClass("offline")
								.html(carousel_info["start_phone_consultation_p"]);
						} else {
							  self.find('.carousel-description span.voice').html('').addClass("offline").removeClass("online");
						}


            //self.find('.carousel-description li.shedule').attr('href', carousel_info['start_live_conversation'] );
					  if (carousel_info["start_video_conversation"] !== undefined) {
			      	  self.find('.carousel-description li.shedule')
										.html(carousel_info["start_video_conversation"])
										.show();
		      	} else {
		      	  	self.find('.carousel-description li.shedule').html('').hide();
						}

						if (carousel_info["start_phone_conversation"] !== undefined) {
								self.find('.carousel-description li.phone')
										.html(carousel_info["start_phone_conversation"])
										.show();
						} else {
							  self.find('.carousel-description li.phone').html('').hide();
						}
						
						if (carousel_info["appt"] !== undefined) {
								self.find('.carousel-description li.appt')
										//.html(carousel_info["appt"])
										.show();
						} else {
							  self.find('.carousel-description li.appt').hide();
						}
						
						

						if (carousel_info["send_text_question"] !== undefined) {
			      		self.find('.carousel-description li.text')
										.html(carousel_info["send_text_question"])
										.show();
						} else {
								self.find('.carousel-description li.text').html('').hide();
						}
            //self.find('.carousel-description a.phone').attr('href', carousel_info['start_live_conversation'] );
            //self.find('.carousel-description a.shedule').attr('href', carousel_info['start_live_conversation'] );
            if ( carousel_info['test'] == true){
  							self.find('.carousel-description .rev_for_js').show().html( carousel_info['link_reviews'] );
  							self.find('.carousel-description .rev_for_js span.number_rev').show().html( carousel_info['reviews'] );
  						} else {
  							self.find('.carousel-description span.number_rev').html('').hide();
  							self.find('.carousel-description a.reviews').html('').hide();
  							self.find('.carousel-description a.yelp_reviews').html('').hide();
  						}

            self.interv = setTimeout( next_image, 2300 );
        }

        function next_image(){
          goto_image( self.current_image<self.images.length-1? self.current_image+1: 0 );
        }
        function prev_image(){
          goto_image( self.current_image>0? self.current_image-1: self.images.length-1 );
        }


        //var cont = $('<div class="controls"></div>');
        var prev = $('<a class="prev icn">prev</a>'); prev.click( prev_image );
        var next = $('<a class="next icn">next</a>'); next.click( next_image );


        //cont.append( prev );
        //cont.append( next );
        self.find('.carousel-image').append(prev).append(next);
        self.interv = setInterval( next_image, 2300 );
    }

    $.fn.dialog = function( ){

        var dialog_div = $( $(this).attr('href') );
        var close = $('<div class="dialog-close"></div>');
        close.click( close_dialogs );
        dialog_div.append( close );

        $('#dialog-overlay').click( function(){
            $('.dialog-window').hide();
            $(this).hide();
            if(isOverlayOpen) postponePayment();
        });

        this.live("click", function(){
            $('#dialog-overlay').show();
            $( $(this).attr('href') ).show();
            if($(this).attr("data-l-id") != undefined){
                $("div#schedule_session span.lawyer_name").html($(this).attr("data-fullname"));
                $("#current_selected_lawyer").attr("data-id", $(this).attr("data-l-id"));
            }
        });

    };

    $.fn.leveled_list = function(){
        this.children().each(function(){
            var self = $(this);
            self.children('.sub').hide();
            self.children('input[type=checkbox]').click( function(){
                if( $(this).attr('checked') == 'checked' ){
                    self.children('.sub').show();
                }else{
                    self.children('.sub').hide();
                }
            });
        });
    };

    (function($){
      //feature detection
      var hasPlaceholder = 'placeholder' in document.createElement('input');

      //sniffy sniff sniff -- just to give extra left padding for the older
      //graphics for type=email and type=url
      var isOldOpera = $.browser.opera && $.browser.version < 10.5;

      $.fn.placeholder = function(options) {
        //merge in passed in options, if any
        var options = $.extend({}, $.fn.placeholder.defaults, options),
        //cache the original 'left' value, for use by Opera later
        o_left = options.placeholderCSS.left;

        //first test for native placeholder support before continuing
        //feature detection inspired by ye olde jquery 1.4 hawtness, with paul irish
        return (hasPlaceholder) ? this : this.each(function() {
      	  //TODO: if this element already has a placeholder, exit

          //local vars
          var $this = $(this),
              inputVal = $.trim($this.val()),
              inputWidth = $this.width(),
              inputHeight = $this.height(),

              //grab the inputs id for the <label @for>, or make a new one from the Date
              inputId = (this.id) ? this.id : 'placeholder' + (+new Date()),
              placeholderText = $this.attr('placeholder'),
              placeholder = $('<span class="placeholder_text"'+'>'+ placeholderText + '</span>');

          //stuff in some calculated values into the placeholderCSS object
          options.placeholderCSS['width'] = inputWidth;
          options.placeholderCSS['height'] = inputHeight;
          options.placeholderCSS['color'] = options.color;

          // adjust position of placeholder
          options.placeholderCSS.left = (isOldOpera && (this.type == 'email' || this.type == 'url')) ?
             '11%' : o_left;
          placeholder.css(options.placeholderCSS);

          //place the placeholder
          $this.wrap(options.inputWrapper);
          $this.attr('id', inputId).after(placeholder);

          //if the input isn't empty
          if (inputVal){
            placeholder.hide();
          };

          //hide placeholder on focus
          $this.focus(function(){
            if (!$.trim($this.val())){
              placeholder.hide();
            };
          });

          //show placeholder if the input is empty
          $this.blur(function(){
            if (!$.trim($this.val())){
              placeholder.show();
            };
          });
        });
      };

      //expose defaults
      $.fn.placeholder.defaults = {
        //you can pass in a custom wrapper
        inputWrapper: '<span style="position:relative; display:block;"></span>',

        //more or less just emulating what webkit does here
        //tweak to your hearts content
        placeholderCSS: {
          'font':'16px',
          'color':'#a8a8a8',
          'position': 'absolute',
          'left':'5%',
          'top':'8px',
          'overflow-x': 'hidden',
          'overflow-y': 'hidden',
    			'display': 'block'
        }
      };
    })(jQuery);

    $('.button')
        .bind( 'mousedown', function(){ $(this).addClass('pressed');    })
        .bind( 'mouseup',   function(){ $(this).removeClass('pressed'); })
        .bind( 'mouseout',  function(){ $(this).removeClass('pressed'); });

    $('.dialog-opener').dialog();
    $('.leveled-list').leveled_list();

    $('.image-carousel').carousel();
    //if (Browser.Version() != 9) {
      $('input[placeholder]').placeholder();
      $('textarea[placeholder]').placeholder();
    //} 
    $(document).keyup(function(e) {
        if (e.keyCode == 27) close_dialogs();
        //if (isOverlayOpen) postponePayment();
    });

  });
});
jQuery.fn.center = function () {
  this.css({"position": "fixed", "margin": "0"});
  this.css("margin-top", ((this.outerHeight()) / 2 * (-1)) + "px");
  this.css("margin-left", ((this.outerWidth()) / 2 * (-1)) + "px");
  this.css("top", "50%");
  this.css("left", "50%");
  return this;
}

$(document).ready(function() {
  if($('div.load-more a').length){
    $(window).scroll(function () {
      if($('div.load-more a').length){
        var eTop = $('div.load-more a').offset().top;
        var offset = eTop - $(window).scrollTop();
        if(offset < 700){
          $("div.load-more a").click();
        }
      }
    });
  }

  // Iphone style for checkbox
  $('#lawyer_is_online').iphoneStyle({
    checkedLabel: 'Available',
    uncheckedLabel: 'Unavailable',
    onChange: function(elem, value) {
      if($(elem)[0].checked==false)
        $.post("/UpdateOnlineStatus", { op: "set_online_status", is_online: false } );
      else
        $.post("/UpdateOnlineStatus", { op: "set_online_status", is_online: true } );
    }
  });

  $('#is_available_by_phone').iphoneStyle({
    checkedLabel: 'Available',
    uncheckedLabel: 'Unavailable',
    onChange: function(elem, value) {
      if($(elem)[0].checked==false)
        $.post("/UpdateOnlineStatus", { op: "set_phone_status", is_available_by_phone: false } );
      else
        $.post("/UpdateOnlineStatus", { op: "set_phone_status", is_available_by_phone: true } );
    }
  });

});

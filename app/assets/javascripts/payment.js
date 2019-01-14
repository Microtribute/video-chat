$(document).ready(function() {
  // this identifies your website in the createToken call below
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))

  // Add this behavior to all text fields
  // $("input[type=text]").each(function() {
	// var default_value = this.value;
	// $(this).focus(function() {
		// if(this.value == default_value) {
			// this.value = '';
		// }
	// });
	// $(this).blur(function() {
		// if(this.value == '') {
			// this.value = default_value;
		// }
	// });
// });

  $("#payment-form").submit(function(event) {
    // disable the submit button to prevent repeated clicks
    $('.submit-button').attr("disabled", "disabled");
    //var fname = $('#card_detail_first_name').val();
    //var lname = $('#card_detail_last_name').val();
    //var full_name = fname + ' ' + lname;
    var card;

    card = {
      number: $('#card_detail_card_number').val(),
      exp_month: $('#card_month').val(),
      exp_year: $('#card_year').val(),
      cvc: $('#card_detail_card_verification').val(),
      //name: full_name ,
      //address_line1: $('#card_detail_address').val(),
      //address_zip: $('#card_detail_postal_code').val(),
      //address_state: $('#card_detail_state').val(),
      //address_country: $('#card_detail_country').val(),
    };
    Stripe.createToken(card, stripeResponseHandler);

    // prevent the form from submitting with the default action
    return false;
  });
});

function stripeResponseHandler(status, response) {
  if (response.error) {
  //show the errors on the form
    $('#stripe_errors').html(response.error.message);
    $('.submit-button').removeAttr("disabled");
  } else {
      var form$ = $("#payment-form");
      // token contains id, last4, and card type
      var token = response['id'];
      $('#stripe_card_token').val(token);
      var form_type = $('#form_type').val();
      if(form_type == "html")
      {
        form$.get(0).submit();
      }
      else
      {
        $.ajax({
        url: "/updatePaymentInfo",
        type:'post',
        data:form$.serialize(),
        success: function(response){
            }
    });

      }
  }
}


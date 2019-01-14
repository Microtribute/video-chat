jQuery ->
  bids.initialize()

bids =
  initialize: ->
    @ensureCardDetails()

  ensureCardDetails: ->
    ($ "form#new_bid").on "submit", (event) =>
      if ($ "input[type=submit]").data("ensure-card-details")
        @processCard()
        false
      else
        true

  processCard: ->
    card =
      number: ($ "#card_number").val()
      cvc: ($ "#card_code").val()
      expMonth: ($ "#card_month").val()
      expYear: ($ "#card_year").val()

    Stripe.createToken(card, bids.handleStripeResponse)


  handleStripeResponse: (status, response) ->
    if status == 200
      ($ "#bid_stripe_card_token").val(response.id)
      ($ "form#new_bid")[0].submit()
    else
      ($ "#stripe_error").text(response.error.message)


jQuery ->
  inquiries.initialize()

inquiries =
  initialize: ->
    @startCountdown()
    @verifyBidAmount()

  startCountdown: ->
    countdownDiv = ($ "body.inquiries.show .countdown")
    untilTime = new Date(Date.UTC(countdownDiv.data("expiration-year"), countdownDiv.data("expiration-month"), countdownDiv.data("expiration-day"), countdownDiv.data("expiration-hours"), countdownDiv.data("expiration-minutes"), countdownDiv.data("expiration-seconds")))

    console.log untilTime

    if countdownDiv.length
      countdownDiv.countdown {
        compact: true,
        description: "",
        until: untilTime
      }

  verifyBidAmount: ->
    ($ "form#new_bid").on "submit", (event) ->
      input = ($ "input#bid_amount")
      minBid = input.data("minimum-bid")

      if parseInt(input.val()) < parseInt(minBid)
        alert "Minimum bid for this inquiry is $#{minBid}.00."
        false
      else
        true

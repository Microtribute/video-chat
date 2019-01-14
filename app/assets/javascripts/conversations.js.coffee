jQuery ->
  conversations.initialize()

conversations =
  initialize: ->
    @handleMessageForm()

  handleMessageForm: ->
    submit_message_button = ($ "body.conversations.summary input#no_answer_message_submit")
    submit_message_button.on "click", ->
      message = ($ "textarea#message").val()
      lawyer_id = ($ "input#lawyer_id").val()
      token = ($ "[name='csrf-token']").attr "content"

      unless message == ""
        $.ajax(
          url: "/ScheduleSession",
          data:
            email_msg: message,
            l2: lawyer_id,
            authenticity_token: token
          beforeSend: ->
            submit_message_button.val "Sending..."
          complete: ->
            submit_message_button.val "Leave message"
          success: (response) ->
            if response == "1"
              alert "Your message has been sent."
            else
              alert "Problem sending message. You may not be logged in."
        )
      else
        alert "You can not send blank message."

jQuery ->
  noLawyerForm.initialize()

noLawyerForm =
  initialize: ->
    @handleFormSubmit()

  handleFormSubmit: ->
    ($ document).on "click", "button#submit_lawyer_request", ->
      $.ajax(
        url: "/users/create_lawyer_request",
        type: "post",
        data:
          request_body: ($ "textarea#lawyer_request_body").val()
        success: ->
          alert "Thanks for letting us know."
      )

jQuery ->
  ($ "body.show button[name='send_inquiry']").on "click", (event) ->
    is_free = ($ this).data("free")

    $.ajax(
      url: "/admin/questions/send_inquiry",
      type: "post",
      data:
        is_free: is_free,
        question_id: ($ "input#question_id").val()
      success: (response) ->
        if response is "sent"
          ($ ".actions > .status").show().text("Emails sent successfully").delay(3000).fadeOut()
    )

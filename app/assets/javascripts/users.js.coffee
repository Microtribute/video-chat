//= require users/home

jQuery ->
  # ($ ".leveled-list input.parent-area").bind "click", ->
  #  value = ($ this).attr("checked") is "checked" ? "true" : "false"
  #  ($ ".sub[data-parent-id='#{($ this).data("id")}']").find("input").attr "checked", value

  # Bind loading spinner to ajaxStart and ajaxStop
  spin_opts = {
    lines: 13,
    length: 7,
    width: 4,
    radius: 11,
    rotate: 0,
    color: '#222',
    speed: 1,
    trail: 60,
    shadow: false,
    hwaccel: false,
    className: 'spinner',
    zIndex: 9999,
    top: 'auto',
    left: 'auto'
  }

  ($ "body.home").ajaxStart -> ($ "body").spin(spin_opts)
  ($ "body.home").ajaxStop -> ($ "body").spin(false)

  # Practice areas checkboxes behavior
  ($ "#leveled-list_practice_areas input.parent-area").bind "change", ->
    input = ($ this)
    parent_id = input.data "id"
    checked = input.is ":checked"

    console.log checked

    children_areas = input.parent().find("[data-parent-id='#{parent_id}'] input")
    children_areas.each (index, element) -> ($ element).attr "checked", checked

  ($ "a#close_notice").bind "click", -> ($ ".notice").hide()

  ($ "a#barids_opener").bind "click", -> ($ "div#bar_membership").center()
  ($ "a#practice_areas_opener").bind "click", -> ($ "div#practices").center()
  ($ "a#start_phone_session_button").bind "click", -> ($ "div#paid_schedule_session").center()

  ($ "a#schedule_session_button").bind "click", ->
    lawyer_name = ($ @).data('fullname')

    ($ "div#schedule_session").center()
    ($ "div#schedule_session span.lawyer_name").html(lawyer_name)

  ($ "input#lawyer_photo").bind "change", ->
    label = ($ "span.file_select_value")
    input_value = ($ @).val()
    label.html(input_value.split(/\\/).pop()) if input_value.length > 0

  ($ "input#lawyer_rate").numeric() # accept only numbers
  ($ "input#lawyer_rate").bind "keyup", ->
    $input = ($ @)
    rate = $input.val().match(/\d+/)[0] unless $input.val() == "" # remove dollar sign
    rate_per_minute = rate / 60

    if $input.val() is ""
      ($ "span.rate_hint").html "Will be quoted by the min."
    else
      ($ "span.rate_hint").html "Quoted as $#{rate_per_minute.toFixed(2)}/minute."

  ($ "a#start_phone_session_button").bind "click", ->
    lawyerid = ($ @).data('attorneyid')
    free_consultation_duration = ($ @).data('fcd')
    lawyer_rate = ($ @).data('lrate')
    lawyer_first_name = ($ @).data('fullname')
    $("#attorney_id").val(lawyerid)
    $('.paid_model_header').html("The first #{free_consultation_duration} minutes with #{lawyer_first_name} are free. To start the phone call, though, we require payment info, as any time past #{free_consultation_duration} minutes is billed at $#{lawyer_rate}/minute.");
    $('#payment_overlay_submit_button').val('Continue');


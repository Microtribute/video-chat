class AppointmentForm
  
  constructor : (lawyer_id)->
    @div = $("#appointment_form_#{lawyer_id}")
    this.add_click_listeners()
    this

  add_click_listeners : ()->
    @div.find("a.appointment-time").click (e)=>
      @div.find("a.appointment-time").removeClass("selected")
      $(e.target).addClass("selected")
      @div.find("#appointment_time").val($(e.target).attr("data-time"))
      @div.find(".appointment-info").html(
        "Appointment set at #{$(e.target).attr("data-time-formatted")}"
      )
      false

    @div.find("a.more").click (e)=>
      @div.find("a.more").parent().hide()
      @div.find("li.hidden").show()
      false

    radios = @div.find(
      "#appointment_appointment_type_phone, " 
      + "#appointment_appointment_type_video"
    )
    radios.click (e)=>
      if $(e.target).attr("checked")
        val = $(e.target).attr("id") == "appointment_appointment_type_video"
        @div.find("#appointment_contact_number").attr('disabled', val)

    radios.each (e)=>
      $(e.target).triggerHandler('click')

    @div.find("form").submit (e)=>
      this.save()
      false


  show : ()->
    @div.find("form").show()
    @div.find("div.message").hide()
    @div.removeClass('consutation_scheduled')
    @div.jqdialog({
      height : 500,
      width : 500,
      modal : true,
      draggable : false,
      resizable : false
    })

  save : ()->
    $.ajax(
      url : "#{@div.find("form").attr("action")}.json",
      type : "POST",
      data : @div.find("form").serialize(),
      dataType : "json"
      statusCode : 
        201 : (data, status, xhr)=>
          this.show_success(data.appointment)
        422 : (xhr, status, text)=>
          this.show_error(JSON.parse(xhr.responseText).appointment.errors)
          true
    )
  # TODO: make this use a templating language
  show_success : (appointment)->
    str = "<h2>Consultation Scheduled.</h2>
      <p>Thanks! Your appointment has been scheduled for #{appointment.time}.
        #{appointment.attorney_name} should be online then, so at
        that time please come to Lawdingo and contact the attorney</p><hr /><a href='#' class='button dialog-close'>Ok</a>"
    @div.find("form").hide()
    @div.find("div.message").html(str).show()
    @div.addClass('consutation_scheduled')

  show_error : (errors)->
    error_string = ""
    $.each(errors, (field, messages)->
      $.each(messages, (j, message)->
        error_string += "#{message}<br/>"
      )
    )
    @div.find("div.error")
      .show()
      .html(error_string)

  select_time : (time)->
    @div.find("a.appointment-time[data-time='#{time}']").click()
    
    
  $(".dialog-close").live "click", ->
    $(".ui-dialog").hide()
    $(".ui-widget-overlay").hide()
    
this.AppointmentForm = AppointmentForm
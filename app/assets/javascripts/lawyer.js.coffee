class Lawyer
  constructor : (id)->
    @id = id
    @form = new AppointmentForm(id)
    @div = $("#lawyer_#{id}")
    @slug = @div.data "lawyer-slug"
    this.add_event_listeners()

  add_event_listeners : ()->
    @div.find("a.appt-select").click (e)=>
      # if logged in, show form
      if $("body.logged-in").length > 0
        @form.select_time(
          $(e.target).attr("data-time")
        )
        @form.show()
      # otherwise redirect
      else
        path = encodeURI(
          # document.location.pathname + document.location.search
          "/attorneys/#{@id}/#{@slug}"
        )
        document.location = "/users/new?notice=true&appointment_with=#{@id}&return_path=#{path}&ut=0"
      # always return false
      return false

@Lawyer = Lawyer

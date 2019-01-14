class Home

  initialize : ()->
    this.add_event_listeners()

    document.my_flag_search=false

    Home.h = {}
    Home.h[198] = 90
    Home.h[169] = 60
    Home.h[141] = 30
    Home.h[113] = 20
    Home.h[84] = 15
    Home.h[56] = 10
    Home.h[28] = 5
    Home.h[0] = 2

    Home.r = {}
    Home.r[198] = 5
    Home.r[148] = 4
    Home.r[99] = 3
    Home.r[49] = 2
    Home.r[0] = 1

    Home.v = {}
    Home.v[198] = 6
    Home.v[131] = 4
    Home.v[65] = 2
    Home.v[0] = 0

    Home.s = {}
    Home.s[198] = 1
    Home.s[131] = 2
    Home.s[65] = 3
    Home.s[0] = 4
  
    this.redirect_to_last_practice_area_state_select_from_cookie()

    unless document.location.hash == ""
      this.set_defaults(default_state)
      this.read_hash()
      this.submit()

  redirect_to_last_practice_area_state_select_from_cookie : ()->
    if document.location.pathname == "/lawyers" && $.cookie('practice_area') && $.cookie('state')
      this.set_state_fields_val($.cookie('state'))
      this.set_practice_area_fields_val($.cookie('practice_area'))
      this.submit()   
  equalHeight = (group) ->
    tallest = 0
    group.each ->
      thisHeight = $(this).height()
      tallest = thisHeight  if thisHeight > tallest
    group.height tallest

  set_auto_detected_state : ()->
    if (!(typeof detect_state_name=="undefined") && !(detect_state_name==""))
      this.set_state_fields_val(detect_state_name+"-lawyers")
    else
      this.set_state_fields_val("All-States")
    $("#question_state_name").val(detect_state_name)
    $("select.states").find("option:contains('"+detect_state_name+"')").prop("selected", "selected")
    $("#need_auto_detect").hide()
    @submit()
    false

  show_hide_link_for_detected_state : ()->
    if (!(typeof detect_state_abbreviation=="undefined") && !(detect_state_abbreviation==""))
      $("#need_auto_detect").text('Set as ' + detect_state_abbreviation)
    else
      $("#need_auto_detect").hide()
    false  

  detect_state : ()->
    $.ajax('/auto-detect/detect-state?autodetect=need',{
      success: () =>
        @show_hide_link_for_detected_state()
      dataType : 'script'
    })

  # quick and dirty - just set the page temporarily
  # we should fix this to keep the page as a variable
  paginate : (page) ->
    this.page = page
    this.submit()
    this.page = null

  submit : ()->
    $.ajax(this.current_search_url(),{
      complete : ()=>
        # listeners for appointment forms
        this.add_appointment_forms()
        this.add_pagination()
      success: () ->
        $(".row").each ->
          equalHeight $(this).find(".row_block")
      dataType : 'script'
    })
    document.location.hash = this.current_hash()
    document.location.hash = document.location.hash.replace /\?\?/, "?"
    document.title = this.current_title().replace /-lawyers/, ""
    new_meta = document.createElement('meta')
    new_meta.name = 'Current'
    new_meta.content = this.current_meta()
    document.getElementsByTagName('head')[0].appendChild(new_meta)
  add_event_listeners : ()->
    this.form().submit(()=>
      this.submit()
      false
    )
    $("#free_minutes_slider").bind "slidechange", (event, ui)=>
      $("#freetimeval").val(Home.h[$("#free_minutes_slider .ui-slider-range").width()])
      this.submit()
      false
    $("#minimum_client_rating").bind "slidechange", (event, ui)=>
      $("#ratingval").val(Home.r[$("#minimum_client_rating .ui-slider-range").width()])
      this.submit()
      false
    $("#hourly_rate").bind "slidechange", (event, ui)=>
      $("#hourlyratestart").val(Home.v[$("#hourly_rate .ui-slider-handle").first().position().left])
      $("#hourlyrateend").val(Home.v[$("#hourly_rate .ui-slider-handle").last().position().left])
      this.submit()
      false
    $("#law_school_quality").bind "slidechange", (event, ui)=>
      $("#schoolrating").val(Home.s[$("#law_school_quality .ui-slider-range").width()])
      this.submit()
      false

    $("a#need_auto_detect").click =>
      this.set_auto_detected_state()
      false
    $("#input_close_sea_img").click =>
      $("#search_query").val('')
      this.set_defaults(default_state)
      this.set_defaults_s()
      $("#input_close_sea_img").hide()
      $("#input_search_bg_img").show()
      this.submit()
      false
    $("#input_search_bg_img").click =>
      this.set_defaults(default_state)
      this.set_defaults_s()
      $("#input_search_bg_img").hide()
      $("#input_close_sea_img").show()
      this.submit()
      false
    $("#search_query").keypress((e) =>
      if e.keyCode == 13
        if !document.my_flag_search && $("#search_query").val()
          document.my_flag_search=true
          $("#input_search_bg_img").hide()
          $("#input_close_sea_img").show()
          $("#search_query").submit()
          false
        this.set_state_fields_val("All-States")
        this.set_practice_area_fields_val("All")
        this.markSelected($('#practice_area_All').parent("p"))
        this.set_defaults(default_state)
        this.submit()
        false
      )
    this.service_type_tabs().click((e)=>
      this.set_service_type_tabs_val(
        $(e.target).attr('data-val')
      )
      this.submit()
      false
    )
    this.practice_area_fields().click((e)=>
      this.set_practice_area_fields_val(
        $(e.target).val()
      )
      $.cookie('practice_area', $(e.target).val(), { expires: 30 });
      this.submit()
    )
    this.state_fields().change((e)=>
      this.set_state_fields_val(
        $(e.target).val()
      )
      $.cookie('state', $(e.target).val(), { expires: 30 });
      @submit()
    )

    this.add_pagination()

  markSelected : (item) ->
    item.siblings().children("input").removeAttr "checked"
    item.siblings().removeClass "selected"
    item.siblings().children('img.radios').attr 'src', "/assets/radio.png"
    item.addClass "selected"
    item.children('img.radios').attr 'src', "/assets/radio_selected.png"

  add_appointment_forms : ()->
    @lawyers = []
    $(".lawyer").each (i, el)=>
      id = $(el).attr("data-lawyer-id")
      if parseInt(id) > 0
        @lawyers.push(new Lawyer(id))

  add_pagination : ()->
    $("div.load-more a").click (e)=>
      this.paginate($(e.target).attr("data-page"))
      $(e.target).html("Loading more lawyers...").unbind()
      false

  current_search_url : ()->
    params = ""
    if this.page
      params += "&page=#{this.page}"
    if $("#search_query").val()
      params += "&search_query=" + $("#search_query").val()
    if $("#freetimeval").val()
      params += "&freetimeval=" + $("#freetimeval").val()
    if $("#ratingval").val()
      params += "&ratingval=" + $("#ratingval").val()
    if ( $("#hourlyratestart").val() && $("#hourlyrateend").val() )
      params += "&hourlyratestart=" + $("#hourlyratestart").val() + "&hourlyrateend=" + $("#hourlyrateend").val()
    if $("#schoolrating").val()
      params += "&schoolrating=" + $("#schoolrating").val()
    if $("#autodetect").val()
      params += "&autodetect=" + $("#autodetect").val()
    if @practice_area == "All"
      "/lawyers/#{@service_type}/#{@state}"+params
    if !@service_type
      @service_type="Legal-Advice"
    if !@state
      @state="All-States"
    if !@practice_area
      @practice_area="All"
    "/lawyers/#{@service_type}/#{@state}/#{@practice_area}"+"?"+params 
  current_hash : ()->
    "!#{this.current_search_url()}"
  current_title : ()->
    if !@service_type
      @service_type="Legal-Advice"
    if !@state
      @state="All-States"
    if !@practice_area
      @practice_area="All"
    service_type = @service_type.replace /-/, " "
    state = @state.replace /-/, " "
    practice_area = @practice_area.replace /-/, " "
    service_type = service_type.replace /\+/, " "
    state = state.replace /\+/, " "
    practice_area = practice_area.replace /\+/, " "
    if (!(typeof detect_state_name=="undefined") && !(detect_state_name==""))
      state=detect_state_name
    "#{service_type} from #{state} #{practice_area} Lawyers. Lawdingo: Ask a Lawyer Online Now"
  current_meta : ()->
    service_type = @service_type.replace /-/, " "
    state = @state.replace /-/, " "
    practice_area = @practice_area.replace /-/, " "
    service_type = service_type.replace /\+/, " "
    state = state.replace /\+/, " "
    practice_area = practice_area.replace /\+/, " "
    if (!(typeof detect_state_name=="undefined") && !(detect_state_name==""))
      state=detect_state_name
    "Ask a #{state} #{practice_area} lawyer for #{service_type} online now on Lawdingo."
  read_hash : ()->
    hash = document.location.hash.replace("#!/lawyers/","")
    first = getUrlVars()["search_query"]
    if first
      $("#search_query").val(first)
      $("#input_search_bg_img").hide()
      $("#input_close_sea_img").show()
      hash = hash.replace("?&search_query=","")
      hash = hash.replace(first,"")
    hash = hash.split("/")
    if (!(typeof detect_state_name=="undefined") && !(detect_state_name==""))
      hash[1]=detect_state_name+"-lawyers"
    this.set_service_type_tabs_val(hash[0])
    this.set_state_fields_val(hash[1])
    
    if hash[2]
      temp_string = hash[2]
      temp_string = temp_string.replace /\+/, " "
      temp_string = temp_string.replace /\+/, " "
      temp_string = temp_string.replace /\+/, " "
      temp_string = temp_string.replace /\?/, ""
      this.set_practice_area_fields_val(temp_string).parent().find('img').trigger('click')
    else
      this.set_practice_area_fields_val("All").parent().find('img').trigger('click')

  set_defaults_s : ()->
   $( "#free_minutes_slider" ).slider(
      value: 1
      )
   $("#hourly_rate").slider
     values: [ 1, 4 ]
     slide: (event, ui) ->
       $("#hourly_rate_in").val "$" + ui.value
   $("#freetimeval").val("")
   $("#hourlyratestart").val("")
   $("#hourlyrateend").val("")

  set_defaults : (default_state)->
    this.set_service_type_tabs_val(
      this.service_type_tabs()
        .filter("[data-default=1]")
        .attr('data-val')
    )
    if (default_state == "")
      this.set_state_fields_val(
        this.state_fields().find("option[data-default=1]").val()
      )
    else
      this.set_state_fields_val(default_state+'-lawyers')
      this.set_practice_area_fields_val(
        this.practice_area_fields()
          .filter("[data-default=1]")
          .val()
      ).parent().find('img').trigger('click')

  tabs : ()->
    $("div#service_type_tabs")

  service_type_tabs : ()->
    this.tabs()
      .find("div#service_type .service_type")

  set_service_type_tabs_val : (val)->
      @service_type = val
      this.service_type_tabs()

        .addClass('selected')
        .filter("[data-val='#{val}']")
        .removeClass("selected")

      if val == "Legal-Services"
        @practice_area_fields().parent().find(".children").hide()
      else
        $field = @practice_area_fields().filter("[checked='checked']")
        $field.parents(".practice-areas").show()
        $field.parent().find(".children").show('slow')

  form : ()->
    $("form.filters")

  state_fields : ()->
    this.form().find("div#state select")

  set_state_fields_val : (val)->
    @state = val
    this.state_fields()
      .val(val)

  #service_type_fields : ()->
  #  this.form()
  #    .find("div#service_type .service_type")

  set_practice_area_fields_val : (val)->
    @practice_area = val

    this.form().find(".children").hide()

    $field = this.practice_area_fields()
      .filter("[value='#{val}']")
      .attr("checked", true)

    is_national = $field.data "is-national"
    $notice_container = ($ @form).find(".national-area-notice")

    if is_national
      # Set state to Any state and hide select field
      this.set_state_fields_val(
        this.state_fields().find(
          "option[data-default=1]"
        ).val()
      )

      ($ @state_fields()).hide()
      ($ "label[for=state]").hide()
      ($ "a#need_auto_detect").hide()

      # Show help notice for national area
      notice = "<span class=\"state\">#{$field.val()}</span> is not state specific."
      $notice_container.show().find("p").html(notice)

      # Show states select field on link click
      show_states_selector_link = $notice_container.find("a.show-states-selector")
      show_states_selector_link.live "click", (event) =>
        event.preventDefault()
        ($ @state_fields()).show()
        ($ "label[for=state]").show()
        $notice_container.hide()
        ($ "a#need_auto_detect").show()
    else
      # Hide notice and show states select field
      ($ @state_fields()).show()
      ($ "label[for=state]").show()
      $notice_container.hide()

    $field.parents(".practice-areas")
      .show()

    $field.parent().next().show() unless @service_type == "Legal-Services"
    $field

  #set_service_type_fields_val : (val)->
  #    @service_type = val
  #    this.service_type_fields()
  #
  #      .removeClass('selected')
  #      .filter("[data-val='#{val}']")
  #      .addClass("selected")
  #
  #    if val == "Legal-Services"
  #      @practice_area_fields().parent().find(".children").hide()
  #    else
  #      $field = @practice_area_fields().filter("[checked='checked']")
  #      $field.parents(".practice-areas").show()
  #      $field.parent().find(".children").show('slow')


  practice_area_fields : ()->
    this.form()
      .find("div#practice_areas input:radio")
  getUrlVars = ->
    vars = []
    hash = undefined
    i = 0
    hashes = window.location.href.slice(window.location.href.indexOf("?") + 1).split("&")
    while i < hashes.length
      hash = hashes[i].split("=")
      vars.push hash[0]
      vars[hash[0]] = hash[1]
      i++
    vars


this.Home = new Home()

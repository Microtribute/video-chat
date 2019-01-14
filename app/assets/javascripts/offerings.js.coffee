jQuery ->
  ($ "input#offering_fee").numeric()

  ($ "li.offering a.edit").bind "click", (event) ->
    event.preventDefault()

    # Revert previuos changes
    ($ "li.offering a.edit").parents("li").removeClass("selected").find(".controls").show()

    li = ($ this).parents("li")
    controls = ($ this).parent("div.controls")

    # Select editing item
    li.addClass("selected")

    # Hide control elements
    controls.hide()
    
    $.ajax(
      url: "/offerings/#{li.data('id')}/edit"
      success: (data) -> ($ "div#new_offering").html(data)
    )

    # Highlight new form
    ($ "div#new_offering").effect("highlight", {}, 1000)

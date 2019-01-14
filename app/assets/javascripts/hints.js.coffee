jQuery ->
  Hints.init()

Hints =
  init: ->
    # scoping a loop with lawyer application form
    ($ "form#new_lawyer *[rel='twipsy']").each (index, element) ->
      field = ($ this)

      field.twipsy {
        animate: false,
        placement: "below",
        trigger: "focus"
      }

      field.bind "blur", ->
        console.log "hidden"
        field.twipsy "hide"

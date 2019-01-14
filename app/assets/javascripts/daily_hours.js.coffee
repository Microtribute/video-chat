# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


class DailyHoursIndex

  initialize : ()->
    $("form#user_daily_hours select").change ()->
      # set both values to closed if either is set to closed
      if $(this).val() == "-1"
        $(this).parent().find("select").val("-1")

this.DailyHoursIndex = new DailyHoursIndex()
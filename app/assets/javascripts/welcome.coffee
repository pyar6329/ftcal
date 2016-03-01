# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  console.log 'hello'
  $('#calendar').fullCalendar
    ## General Display ##
    header:
      # left: 'prev,next today'
      left: ''
      center: 'title'
      right: ''
      # right: 'month,agendaWeek,agendaDay'
      # right: 'agendaTwoWeek'
      # right: 'agendaTwoWeek,agendaWeek,agendaDay'
    # aspectRatio: 1.35
    # editable: true
    # eventLimit: true
    height: 550
    ## Timezone ##
    timezone: 'local'

    ## Views ##
    defaultView: 'agendaTwoWeek'
    views:
      agendaTwoWeek:
        type: 'agenda'
        duration: { weeks: 2 }
        buttonText: '2 week'
        # titleFormat: 'MM/DD'
        columnFormat: 'ddd M/D'

    ## Agenda Options ##
    allDaySlot: false
    slotLabelFormat: 'H:mm'
    scrollTime: '00:00:00'

    ## Current Date ##
    defaultDate: '2016-01-19'
    nowIndicator: true

    ## Text/Time Customization ##
    # columnFormat: 'M/D'

    ## Event Data ##
    events: (start, end, timezone, callback) ->
      $.ajax
        url: '/api/v1/free_time'
        dataType: 'json'
        method: 'GET'
        success: (response) ->
          events = []
          for data in response
            events.push
              title: 'free time'
              start: data.startTime
              end: data.endTime
          console.log 'events'
          console.log events
          callback events
  # bootstrap theme
  $('#calendar button').addClass('btn btn-default')
  $('.fc-view > table').wrapInner('<div id="cal-data"></div>')
  # $('.fc-row').find('tr').wrapInner('<div id="cal-header"></div>')
  # $('.fc-axis').wrap('<div id="cal-header-axis"></div>')
  # $('.fc-day-header').wrapAll('<div id="cal-header-column"></div>')
  # $('.fc-day').wrapAll('<div id="cal-body"></div>')

  return

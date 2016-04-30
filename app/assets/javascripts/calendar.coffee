# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  browser_lang = (navigator.userLanguage || navigator.browserLanguage || navigator.language).substr(0, 2)
  browser_lang = 'en' if browser_lang != 'ja'
  i18n_lists =
    "#nav_signout": I18n.t("nav.signout")
    "#nav_signin": I18n.t("nav.signin")
  for key, value of i18n_lists
    $(key).text(value)

  calendar = $('#calendar').fullCalendar
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
    height: $(window).height() * 0.85
    firstDay: (new Date).getDay()

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
    # defaultDate: '2016-01-17'
    nowIndicator: true

    ## Text/Time Customization ##
    # columnFormat: 'M/D'
    lang: I18n.locale#browser_lang

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
          console.log('events')
          console.log(events)
          callback(events)

    ## Event Rendering ##
    eventAfterAllRender: ->
      # bootstrap theme
      $('#calendar button').addClass('btn btn-default')
      $('.fc-view > table').wrapInner('<div id="cal-data"></div>')
      # $('#calendar').height()
      # $('.fc-row').find('tr').wrapInner('<div id="cal-header"></div>')
      # $('.fc-axis').wrap('<div id="cal-header-axis"></div>')
      # $('.fc-day-header').wrapAll('<div id="cal-header-column"></div>')
      # $('.fc-day').wrapAll('<div id="cal-body"></div>')
  if calendar
    $(window).resize ->
      cal_height = $(window).height() * 0.85
      $('#calendar').fullCalendar('option', 'height', cal_height)

$(document).on('ready page:load', ready)

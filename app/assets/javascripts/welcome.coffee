# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  console.log 'hello'
  $('#calendar').fullCalendar
    header:
      left: 'prev,next today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    defaultDate: '2016-01'
    # editable: true
    # eventLimit: true
    timezone: 'local'
    events: [
      {
        title: 'free time'
        start: '2016-01-16T09:00:00+09:00'
        end: '2016-01-16T10:30:00+09:00'
      }
      {
        title: 'free time'
        start: '2016-01-19T10:00:00+09:00'
        end: '2016-01-19T11:30:00+09:00'
      }
      {
        title: 'free time'
        start: '2016-01-20T18:30:00+09:00'
        end: '2016-01-20T20:00:00+09:00'
      }
      {
        title: 'free time'
        start: '2016-01-22T18:30:00+09:00'
        end: '2016-01-22T20:00:00+09:00'
      }
      {
        title: 'free time'
        start: '2016-01-23T09:00:00+09:00'
        end: '2016-01-23T10:30:00+09:00'
      }
      {
        title: 'free time'
        start: '2016-01-26T10:00:00+09:00'
        end: '2016-01-26T11:30:00+09:00'
      }
      {
        title: 'free time'
        start: '2016-01-27T18:30:00+09:00'
        end: '2016-01-27T20:00:00+09:00'
      }
      {
        title: 'free time'
        start: '2016-01-29T18:30:00+09:00'
        end: '2016-01-29T20:00:00+09:00'
      }
    ]
  return

require 'google/api_client'
require 'google/api_client/client_secrets'
# require 'google/api_client/auth/file_storage'

module GoogleCalendarAPI
  extend ActiveSupport::Concern

  def hoge
    # sample
    # https://github.com/google/google-api-ruby-client-samples/blob/master/calendar/calendar.rb
    # https://github.com/google/google-api-ruby-client/blob/master/lib/google/api_client/client_secrets.rb
    # puts "hellllllllllllllllllllllllllllllllllllllo"
    # client = Google::APIClient.new
    # client.authorization.access_token = current_user.token
    # calendar = client.discovered_api('calendar', 'v3')
    # year = 2016
    # month = 1
    # calendar_params = { 'calendarId' => current_user.email,
                        # 'orderBy' => 'startTime',
                        # 'timeMax' => Time.utc(year, month, 31, 0).iso8601,
                        # 'timeMin' => Time.utc(year, month, 1, 0).iso8601,
                        # 'singleEvents' => 'True',
    #                     'sendNotifications' => true
    #                   }
    # event = {
    #   'summary' => 'New Event Title',
    #   'description' => 'The description',
    #   'location' => 'Location',
    #   'start' => { 'dateTime' => Chronic.parse('tomorrow 4 pm') },
    #   'end' => { 'dateTime' => Chronic.parse('tomorrow 5pm') },
    #   'attendees' => [{ "email" => 'hoge@gmail.com' }]
    # }
    #
    # result = client.execute(api_method: calendar.events.list,
    #                         parameters: calendar_params,
    #                         body: JSON.dump(event),
    #                         headers: {'Content-Type' => 'application/json'})
    # events = []
    # result.data.items.each do |item|
      # events.push(item)
    # end
    # return events
    # return result
  end
end

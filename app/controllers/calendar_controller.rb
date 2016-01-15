require 'google/api_client'
require 'google/api_client/client_secrets'

class CalendarController < ApplicationController
  before_action :authenticate_user!
  # include GoogleCalendarAPI

  def index

    client = Google::APIClient.new(application_name: 'xxx', application_version: '0.0.1')
    client.authorization.client_id = ENV['GOOGLE_CLIENT_ID']
    client.authorization.client_secret = ENV['GOOGLE_CLIENT_SECRET']
    client.authorization.access_token = current_user.token
    client.authorization.scope = 'https://www.googleapis.com/auth/calendar.readonly'

    calendar = client.discovered_api('calendar', 'v3')

    params = {'calendarId' => current_user.email,
              'orderBy' => 'startTime',
              'timeMax' => Time.utc(2014, 3, 31, 0).iso8601,
              'timeMin' => Time.utc(2014, 3, 1, 0).iso8601,
              'singleEvents' => 'True'}

    event = client.execute(api_method: calendar.events.list,
                            parameters: params)
    @set_event = event
    # @set_event = current_user.to_json
    # @google_oauth2_info = hoge # concernのメソッドを実行
    # @google_oauth2_info = current_user.token
  end
end

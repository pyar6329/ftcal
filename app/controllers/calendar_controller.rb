require 'google/api_client'
require 'google/api_client/client_secrets'

# http://blog.ishotihadus.com/?p=122 参考

class CalendarController < ApplicationController
  before_action :authenticate_user!
  # include GoogleCalendarAPI

  def index
    # client = Google::APIClient.new(application_name: 'xxx', application_version: '0.0.1')
    client = Google::APIClient.new#(auto_refresh_token: true)

    # client_secrets = Google::APIClient::ClientSecrets.load
    # authorization = client_secrets.to_authorization
    # auth_client.update!(scope: 'https://www.googleapis.com/auth/calendar',
                        # redirect_uri: 'urn:ietf:wg:oauth:2.0:oob')

    # client.authorization.client_id = ENV['GOOGLE_CLIENT_ID']
    # client.authorization.client_secret = ENV['GOOGLE_CLIENT_SECRET']
    client.authorization.access_token = current_user.token
    # client.authorization.refresh_token = current_user.refresh_token
    # client.authorization.scope = 'https://www.googleapis.com/auth/calendar.readonly'
    # token = client.authorization.fetch_access_token["access_token"]
    calendar = client.discovered_api('calendar', 'v3')

    params = {'calendarId' => current_user.email,
              'orderBy' => 'startTime',
              'timeMax' => Time.utc(2014, 3, 31, 0).iso8601,
              'timeMin' => Time.utc(2014, 3, 1, 0).iso8601,
              'singleEvents' => 'True'}

    response = client.execute(api_method: calendar.events.list,
                            parameters: params,
                            headers: { 'Content-Type' => 'application/json' })

    events = []
    response.data.items.each do |item|
      events << item
    end

    @set_event = events
    # @set_event = current_user.to_json
    # @google_oauth2_info = hoge # concernのメソッドを実行
    # @google_oauth2_info = current_user.token
  end
end

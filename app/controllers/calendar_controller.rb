require 'google/api_client'
require 'google/api_client/client_secrets'

# http://blog.ishotihadus.com/?p=122 参考

class CalendarController < ApplicationController
  # before_action :authenticate_user!
  # include GoogleCalendarAPI

  def index
    # client = Google::APIClient.new(application_name: 'xxx', application_version: '0.0.1')
    # client = Google::APIClient.new#(auto_refresh_token: true)

    # client_secrets = Google::APIClient::ClientSecrets.load
    # authorization = client_secrets.to_authorization
    # auth_client.update!(scope: 'https://www.googleapis.com/auth/calendar',
                        # redirect_uri: 'urn:ietf:wg:oauth:2.0:oob')

    # client.authorization.client_id = ENV['GOOGLE_CLIENT_ID']
    # client.authorization.client_secret = ENV['GOOGLE_CLIENT_SECRET']
    # client.authorization.access_token = current_user.token
    # client.authorization.refresh_token = current_user.refresh_token
    # client.authorization.scope = 'https://www.googleapis.com/auth/calendar.readonly'
    # token = client.authorization.fetch_access_token["access_token"]
    # calendar = client.discovered_api('calendar', 'v3')
    # puts Time.zone.now.in_time_zone('Tokyo')
    # Time.zone.now.in_time_zone('Tokyo') + 2.weeks

    # current_times = Time.zone.now
    # two_weeks_later = Time.zone.now + 2.weeks
    #
    # params = {calendarId: current_user.email,
    #           orderBy: 'startTime',
    #           timeMin: current_times.iso8601,
    #           timeMax: two_weeks_later.iso8601,
    #           singleEvents: 'True'}
    #
    # response = client.execute(api_method: calendar.events.list,
    #                           parameters: params#,
    #                           # headers: { 'Content-Type' => 'application/json' }
    #                           )

    # events = []
    # response.data.items.each do |item|
    #   events << item
    # end

    # 今回は空き時間を表示するので、タイトルと詳細はいらない
    # events.each  do |event|
    #   event.summary # タイトル
    #   event.description # 詳細。nullで存在しない場合有り。
    #   event.start.dateTime # 開始時刻
    #   event.start.date # 全日単位の開始時刻
    #   event.end.dateTime # 終了時刻
    #   event.end.date # 全日単位の終了時刻
    # end

    # APIアクセスしなくてもいい用 ここから
    require 'json'
    json_file_path = Rails.root.join('spec', 'data', 'true_calendar.json').to_s
    events = open(json_file_path, 'r') do |io|
      JSON.load(io)
    end

    # APIアクセスしなくてもいい用 ここまで

    ans = []

    events.each_cons(events.length) do |eventA, eventB|
      temphash = {}
      temphash['eventA'] = eventA.summary
      temphash['eventB'] = eventB.summary
      ans << temphash
      # ans << "eventA.summary = #{eventA}, eventB.summary = #{eventB}"
      # event.summary # タイトル
      # event.description # 詳細。nullで存在しない場合有り。
      # event.start.dateTime # 開始時刻
      # event.start.date # 全日単位の開始時刻
      # event.end.dateTime # 終了時刻
      # event.end.date # 全日単位の終了時刻
    end


    @set_event = ans#events
    render json: @set_event

    # @google_oauth2_info = hoge # concernのメソッドを実行
    # @google_oauth2_info = current_user.token
  end
end

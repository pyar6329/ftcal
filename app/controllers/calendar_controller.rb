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

    # events.each_cons(2) do |eventA, eventB|
    #   temphash = {}
    #   temphash['eventA'] = {
    #     summary: eventA['summary'],
    #     startTime: eventA['start']['dateTime'],
    #     endTime: eventA['end']['dateTime']
    #   }
    #   temphash['eventB'] = {
    #     summary: eventB['summary'],
    #     startTime: eventB['start']['dateTime'],
    #     endTime: eventB['end']['dateTime']
    #   }
    #
    #   # 時間が重なっている場合
    #   if eventB['start']['dateTime'] <= eventA['end']['dateTime'] &&
    #     eventA['start']['dateTime'] <= eventB['end']['dateTime']
    #     startTime = eventA['start']['dateTime'] > eventB['start']['dateTime'] ? eventB['start']['dateTime'] : eventA['start']['dateTime']
    #     endTime = eventA['end']['dateTime'] > eventB['end']['dateTime'] ? eventB['end']['dateTime'] : eventA['end']['dateTime']

    events.each do |event|

      # 全日単位の予定はskip
      next if event['start']['dateTime'].blank? || event['end']['dateTime'].blank?

      temphash = {
        startTime: event['start']['dateTime'],
        endTime: event['end']['dateTime']
      }.with_indifferent_access
      # 初期値を入力
      ans << temphash if ans.empty?
      # a1 = Time.iso8601(ans.last['startTime'])
      # a2 = Time.iso8601(event['end']['dateTime'])
      # b1 = Time.iso8601(event['start']['dateTime'])
      # b2 = Time.iso8601(ans.last[:endTime])

      # 被ってたら
      if Time.iso8601(ans.last['startTime']) <= Time.iso8601(event['end']['dateTime']) && Time.iso8601(event['start']['dateTime']) <= Time.iso8601(ans.last['endTime'])
        # startTimeは数値が小さい方(早い時間)を入れる
        ans.last['startTime'] = event['start']['dateTime'] > ans.last['startTime'] ? ans.last['startTime'] : event['start']['dateTime']
        # endTimeは数値が大きい方(遅い時間)を入れる
        ans.last['endTime'] = event['end']['dateTime'] > ans.last['endTime'] ? event['end']['dateTime'] : ans.last['endTime']
      # 被ってなかったら要素で新規追加
      else
        ans << temphash
      end
    end

      # ans << temphash
      # ans << "eventA.summary = #{eventA}, eventB.summary = #{eventB}"
      # event.summary # タイトル
      # event.description # 詳細。nullで存在しない場合有り。
      # event.start.dateTime # 開始時刻
      # event.start.date # 全日単位の開始時刻
      # event.end.dateTime # 終了時刻
      # event.end.date # 全日単位の終了時刻
    # end


    @set_event = ans#events
    render json: @set_event

    # @google_oauth2_info = hoge # concernのメソッドを実行
    # @google_oauth2_info = current_user.token
  end
end

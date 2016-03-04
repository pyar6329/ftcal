require 'google/api_client'
require 'google/api_client/client_secrets'

# http://blog.ishotihadus.com/?p=122 参考

class Api::V1::FreeTimeController < ApplicationController
  before_action :authenticate_user!
  # include GoogleCalendarAPI

  def initialize
    # UTCで初期化
    @start_time_today = Time.zone.now#.beginning_of_day
    @end_time_after_2weeks = (Time.zone.now + 2.weeks)#.beginning_of_day
  end

  def index
    client = Google::APIClient.new(application_name: 'ftcal', application_version: '0.9.0')
    # client = Google::APIClient.new#(auto_refresh_token: true)

    # client_secrets = Google::APIClient::ClientSecrets.load
    # authorization = client_secrets.to_authorization
    # auth_client.update!(scope: 'https://www.googleapis.com/auth/calendar', redirect_uri: 'urn:ietf:wg:oauth:2.0:oob')

    # client.authorization.client_id = ENV['GOOGLE_CLIENT_ID']
    # client.authorization.client_secret = ENV['GOOGLE_CLIENT_SECRET']
    client.authorization.access_token = current_user.token
    # client.authorization.refresh_token = current_user.refresh_token
    # client.authorization.scope = 'https://www.googleapis.com/auth/calendar.readonly'
    # token = client.authorization.fetch_access_token["access_token"]
    calendar = client.discovered_api('calendar', 'v3')
    # puts Time.zone.now.in_time_zone('Tokyo')
    # Time.zone.now.in_time_zone('Tokyo') + 2.weeks

    # @start_time_today = Time.zone.now.beginning_of_day
    # @end_time_after_2weeks = (Time.zone.now + 2.weeks).beginning_of_day

    params = {
      calendarId: current_user.email,
      orderBy: 'startTime',
      timeMin: @start_time_today.iso8601,
      timeMax: @end_time_after_2weeks.iso8601,
      singleEvents: 'True'
    }

    response = client.execute(
      api_method: calendar.events.list,
      parameters: params # ,
      # headers: { 'Content-Type' => 'application/json' }
    )

    events = []
    response.data.items.each do |item|
      events << item
    end

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
    # require 'json'
    # json_file_path = Rails.root.join('spec', 'data', 'true_calendar.json').to_s
    # events = open(json_file_path, 'r') do |io|
    #   JSON.load(io)
    # end

    # APIアクセスしなくてもいい用 ここまで

    ans = []

    events.each do |event|
      # Googleから取得した時間をUTCに変換
      start_time = event['start']['dateTime'].in_time_zone.to_s
      end_time = event['end']['dateTime'].in_time_zone.to_s
      # start_time = Time.parse(event['start']['dateTime'].to_s).in_time_zone.to_s
      # end_time = Time.parse(event['end']['dateTime'].to_s).in_time_zone.to_s

      # 全日単位の予定はskip
      next if start_time.blank? || end_time.blank?

      temphash = {
        startTime: start_time,
        endTime: end_time
      }#.with_indifferent_access
      # 初期値を入力
      ans << temphash if ans.empty?

      before_start_time = ans.last[:startTime]
      before_end_time = ans.last[:endTime]

      parsed_before_start_time = Time.parse(before_start_time)#.in_time_zone
      parsed_end_time = Time.parse(end_time)#.in_time_zone
      parsed_start_time = Time.parse(start_time)#.in_time_zone
      parsed_before_end_time = Time.parse(before_end_time)#.in_time_zone
      # raise 'hello'
      # 被ってたら
      if parsed_before_start_time <= parsed_end_time && parsed_start_time <= parsed_before_end_time
        # startTimeは数値が小さい方(早い時間)を入れる
        ans.last[:startTime] = parsed_start_time > parsed_before_start_time ? parsed_before_start_time.iso8601.to_s : parsed_start_time.iso8601.to_s
        # endTimeは数値が大きい方(遅い時間)を入れる
        ans.last[:endTime] = parsed_end_time > parsed_before_end_time ? parsed_end_time.iso8601.to_s : parsed_before_end_time.iso8601.to_s
      # 被ってなかったら要素で新規追加
      else
        ans << temphash
      end
    end

    # @set_event = ans
    @set_event = convert_free_time(ans) # ans # events
    render json: @set_event

    # @google_oauth2_info = hoge # concernのメソッドを実行
    # @google_oauth2_info = current_user.token
  end

  private

  def convert_free_time(ans)
    # @start_time_today = '2016-01-16T00:00:00+09:00' # @start_time_today.iso8601
    # @end_time_after_2weeks = '2016-01-30T00:00:00+09:00'
    user_time_zone = 'Tokyo'
    converted_time_lists = []
    (ans.size + 1).times do |i|
      temphash = {
        startTime: i == 0 ? @start_time_today.in_time_zone(user_time_zone).beginning_of_day.iso8601.to_s : ans[i - 1][:endTime],
        endTime: i == ans.size ? @end_time_after_2weeks.in_time_zone(user_time_zone).beginning_of_day.iso8601.to_s : ans[i][:startTime]
      }
      converted_time_lists << temphash unless temphash[:startTime] == temphash[:endTime]
    end
    converted_time_lists
  end
end

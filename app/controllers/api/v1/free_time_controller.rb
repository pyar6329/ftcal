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
    @user_time_zone = 'Tokyo'
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

    events = response.data.items.map { |i| i }

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

    ans = events.select { |event|
      event['start']['dateTime'].present? && event['end']['dateTime'].present? # 時間単位
    }.map { |event|
      { startTime: event['start']['dateTime'].in_time_zone.to_s,
        endTime: event['end']['dateTime'].in_time_zone.to_s,
      }
    }

    # overtimeが追加されたデータ
    added_eventlists = add_overtime(ans)

    # 重複を覗いたデータ
    unique_eventlists = to_unique_event(added_eventlists)

    # 予定時間から自由時間に変換
    converted_time_lists = convert_free_time(unique_eventlists)

    # 1時間以上予定が開いているものを取得
    larger_than_1hour_lists = get_larger_than_1hour(converted_time_lists)

    # @set_event = ans
    # @set_event = add_overtime
    # @set_event = add_overtime(ans)
    # @set_event = added_eventlists
    # @set_event = unique_eventlists
    # @set_event = converted_time_lists
    # @set_event = convert_free_time(ans) # ans # events
    @set_event = larger_than_1hour_lists

    render json: @set_event

    # @google_oauth2_info = hoge # concernのメソッドを実行
    # @google_oauth2_info = current_user.token
  end

  private

  # 20~10時、土曜00時~月曜00時を追加する
  def add_overtime(ans)

    # Timezoneに直す
    ans = ans.map { |i|
      { startTime: i[:startTime].in_time_zone(@user_time_zone),
        endTime: i[:endTime].in_time_zone(@user_time_zone),
      }
    }

    # 2週間の前後の空白期間を追加
    today = @start_time_today.in_time_zone(@user_time_zone)
    overtime_lists = (0..15).map { |i|
      { startTime: today.yesterday.change(hour: 20) + i.days,
        endTime: today.change(hour: 10) + i.days,
      }
    }

    # 日曜日だけ要素数が3つ、それ以外は2つ
    holiday_lists_size = today.wday == 0 ? 0..2 : 0..1
    this_saturday = today.beginning_of_week + 5.days
    next_monday = today.beginning_of_week + 7.days

    # 土日の期間を追加
    holiday_lists = (holiday_lists_size).map { |i|
      { startTime: this_saturday + i.weeks,
        endTime: next_monday + i.weeks,
      }
    }

    # 3つを結合し、startTime順にソート
    overtime_lists.concat(holiday_lists).concat(ans).sort_by { |i| i[:startTime] }

  end

  # 重複した要素を除く
  def to_unique_event(ans = nil)
    unique_eventlists = []

    # reduce / injectを使うと楽かも
    # http://qiita.com/shibukk/items/d985d014de598d925b8b
    ans.each do |event|
      temphash = {
        startTime: event[:startTime],
        endTime: event[:endTime]
      }
      # 初期値を入力
      unique_eventlists << temphash if unique_eventlists.empty?

      # parsed_before_start_time = unique_eventlists.last[:startTime]
      # parsed_before_end_time = unique_eventlists.last[:endTime]
      parsed_start_time = event[:startTime]
      parsed_end_time = event[:endTime]

      parsed_before_start_time = Time.parse(unique_eventlists.last[:startTime].to_s)
      parsed_before_end_time = Time.parse(unique_eventlists.last[:endTime].to_s)
      # parsed_start_time = Time.parse(event[:startTime].to_s)
      # parsed_end_time = Time.parse(event[:endTime].to_s)
      # 被ってたら
      if parsed_before_start_time <= parsed_end_time && parsed_start_time <= parsed_before_end_time
        # startTimeは数値が小さい方(早い時間)を入れる
        unique_eventlists.last[:startTime] = parsed_start_time > parsed_before_start_time ? parsed_before_start_time.iso8601.to_s : parsed_start_time.iso8601.to_s
        # endTimeは数値が大きい方(遅い時間)を入れる
        unique_eventlists.last[:endTime] = parsed_end_time > parsed_before_end_time ? parsed_end_time.iso8601.to_s : parsed_before_end_time.iso8601.to_s
      # 被ってなかったら要素で新規追加
      else
        unique_eventlists << temphash
      end
    end

    today_iso8601_s = @start_time_today.in_time_zone(@user_time_zone).beginning_of_day.iso8601.to_s
    timezoned_today = Time.parse(today_iso8601_s)
    after_2weeks_iso8601_s = @end_time_after_2weeks.in_time_zone(@user_time_zone).beginning_of_day.iso8601.to_s
    timezoned_after_2week = Time.parse(after_2weeks_iso8601_s)

    unique_first = Time.parse(unique_eventlists.first[:startTime])
    unique_last = Time.parse(unique_eventlists.last[:endTime].to_s)

    unique_eventlists.first[:startTime] = today_iso8601_s if unique_first < timezoned_today
    unique_eventlists.last[:endTime] = after_2weeks_iso8601_s if unique_last > timezoned_after_2week

    unique_eventlists
  end

  # 予定時間 → 空き時間に変換する
  def convert_free_time(ans)
    converted_time_lists = []
    timezoned_today = @start_time_today.in_time_zone(@user_time_zone).beginning_of_day.iso8601.to_s
    timezoned_after_2week = @end_time_after_2weeks.in_time_zone(@user_time_zone).beginning_of_day.iso8601.to_s

    (ans.size + 1).times do |i|
      temphash = {
        startTime: i == 0 ? timezoned_today : ans[i - 1][:endTime],
        endTime: i == ans.size ? timezoned_after_2week : ans[i][:startTime]
      }
      converted_time_lists << temphash unless temphash[:startTime] == temphash[:endTime]
    end
    converted_time_lists
  end

  # 1時間以上予定が開いているものを取得
  def get_larger_than_1hour(ans)
    ans.select do |s|
      (Time.parse(s[:endTime].to_s) - Time.parse(s[:startTime].to_s)) >= 3600
    end
  end
end

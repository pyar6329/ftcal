require "google/api_client"
require "google/api_client/client_secrets"
class Calendar
  def initialize(params)
    # UTCで初期化
    @start_time_today = params[:browser_time]
    @end_time_after_2weeks = (params[:browser_time] + 2.weeks)
    @user_time_zone = "Tokyo"
    @current_user = params[:current_user]
  end

  def index
    client = Google::APIClient.new(application_name: "ftcal", application_version: "0.9.0")
    client.authorization.access_token = @current_user.token
    calendar = client.discovered_api("calendar", "v3")
    params = {
      calendarId: @current_user.email,
      orderBy: "startTime",
      timeMin: @start_time_today.iso8601,
      timeMax: @end_time_after_2weeks.iso8601,
      singleEvents: "True"
    }

    response = client.execute(
      api_method: calendar.events.list,
      parameters: params
    )

    events = response.data.items.map { |i| i }
    ans = events.select { |event|
      event["start"]["dateTime"].present? && event["end"]["dateTime"].present? # 時間単位
    }.map { |event|
      { startTime: event["start"]["dateTime"].in_time_zone.to_s,
        endTime: event["end"]["dateTime"].in_time_zone.to_s,
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

    @set_event = larger_than_1hour_lists
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

      parsed_start_time = event[:startTime]
      parsed_end_time = event[:endTime]

      parsed_before_start_time = Time.parse(unique_eventlists.last[:startTime].to_s)
      parsed_before_end_time = Time.parse(unique_eventlists.last[:endTime].to_s)
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

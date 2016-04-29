require "rails_helper"

RSpec.describe Calendar, type: :model do
  # ログインユーザ
  let(:correct_user) { build(:user) }

  # カレンダーオブジェクト
  let(:calendar) {
    Calendar.new({
      current_user: correct_user,
      # browser_time: Time.zone.now
      browser_time: Time.parse("2016-04-26T21:00:00+09:00")
    })
  }

  let(:calendar_data_for_google) {
    [
      {
        "kind" => "calendar#event",
        "etag" => "\"#{generate(:number)}\"",
        "id" => generate(:password),
        "status" => "confirmed",
        "htmlLink" => generate(:url),
        "created" => generate(:time),
        "updated" => generate(:time),
        "summary" => generate(:title),
        "creator" => {
          "email" => generate(:email),
          "displayName" => generate(:name),
          "self" => true
        },
        "organizer" => {
          "email" => generate(:email),
          "displayName" => generate(:name),
          "self" => true
        },
        "start" => {
          "dateTime" => "2016-04-27T11:00:00+09:00"
        },
        "end" => {
          "dateTime" => "2016-04-27T14:00:00+09:00"
        },
        "transparency" => "transparent",
        "iCalUID" => generate(:email),
        "sequence" => 1,
        "reminders" => {
          "useDefault" => false,
          "overrides" => [
            {
              "method" => "popup",
              "minutes" => 30
            },
            {
              "method" => "email",
              "minutes" => 450
            }
          ]
        }
      }
    ]
  }
  # describe "#get_calendar_for_google_api" do
  #   it "is valid" do
  #     return_calendar_data = calendar.send(:get_calendar_for_google_api)
  #     expect(return_calendar_data).to include(:startTime)
  #   end
  # end

  describe "#get_schedule" do
    it "is valid" do
      return_calendar_data = calendar.send(:get_schedule, calendar_data_for_google)
      expected_calendar_data = [
        { startTime: "2016-04-27T11:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00"}
      ]
      expect(return_calendar_data).to eq(expected_calendar_data)
    end
  end

  describe "#add_overtime" do
    # UTCのデータのとき
    it "is valid UTC data" do
      calendar_data = [
        { startTime: "2016-04-27T02:00:00+00:00", endTime: "2016-04-27T05:00:00+00:00" }
      ]
      return_add_overtime = calendar.send(:add_overtime, calendar_data)
      expected_calendar_data = [
        { startTime: "2016-04-25T20:00:00+09:00", endTime: "2016-04-26T10:00:00+09:00" },
        { startTime: "2016-04-26T20:00:00+09:00", endTime: "2016-04-27T10:00:00+09:00" },
        { startTime: "2016-04-27T11:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00" },
        { startTime: "2016-04-27T20:00:00+09:00", endTime: "2016-04-28T10:00:00+09:00" },
        { startTime: "2016-04-28T20:00:00+09:00", endTime: "2016-04-29T10:00:00+09:00" },
        { startTime: "2016-04-29T20:00:00+09:00", endTime: "2016-04-30T10:00:00+09:00" },
        { startTime: "2016-04-30T00:00:00+09:00", endTime: "2016-05-02T00:00:00+09:00" },
        { startTime: "2016-04-30T20:00:00+09:00", endTime: "2016-05-01T10:00:00+09:00" },
        { startTime: "2016-05-01T20:00:00+09:00", endTime: "2016-05-02T10:00:00+09:00" },
        { startTime: "2016-05-02T20:00:00+09:00", endTime: "2016-05-03T10:00:00+09:00" },
        { startTime: "2016-05-03T20:00:00+09:00", endTime: "2016-05-04T10:00:00+09:00" },
        { startTime: "2016-05-04T20:00:00+09:00", endTime: "2016-05-05T10:00:00+09:00" },
        { startTime: "2016-05-05T20:00:00+09:00", endTime: "2016-05-06T10:00:00+09:00" },
        { startTime: "2016-05-06T20:00:00+09:00", endTime: "2016-05-07T10:00:00+09:00" },
        { startTime: "2016-05-07T00:00:00+09:00", endTime: "2016-05-09T00:00:00+09:00" },
        { startTime: "2016-05-07T20:00:00+09:00", endTime: "2016-05-08T10:00:00+09:00" },
        { startTime: "2016-05-08T20:00:00+09:00", endTime: "2016-05-09T10:00:00+09:00" },
        { startTime: "2016-05-09T20:00:00+09:00", endTime: "2016-05-10T10:00:00+09:00" },
        { startTime: "2016-05-10T20:00:00+09:00", endTime: "2016-05-11T10:00:00+09:00" }
      ]
      expect(return_add_overtime).to eq(expected_calendar_data)
    end
    # JSTのデータのとき
    it "is valid JST data" do
      calendar_data = [
        { startTime: "2016-04-27T11:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00" },
      ]
      return_add_overtime = calendar.send(:add_overtime, calendar_data)
      expected_calendar_data = [
        { startTime: "2016-04-25T20:00:00+09:00", endTime: "2016-04-26T10:00:00+09:00" },
        { startTime: "2016-04-26T20:00:00+09:00", endTime: "2016-04-27T10:00:00+09:00" },
        { startTime: "2016-04-27T11:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00" },
        { startTime: "2016-04-27T20:00:00+09:00", endTime: "2016-04-28T10:00:00+09:00" },
        { startTime: "2016-04-28T20:00:00+09:00", endTime: "2016-04-29T10:00:00+09:00" },
        { startTime: "2016-04-29T20:00:00+09:00", endTime: "2016-04-30T10:00:00+09:00" },
        { startTime: "2016-04-30T00:00:00+09:00", endTime: "2016-05-02T00:00:00+09:00" },
        { startTime: "2016-04-30T20:00:00+09:00", endTime: "2016-05-01T10:00:00+09:00" },
        { startTime: "2016-05-01T20:00:00+09:00", endTime: "2016-05-02T10:00:00+09:00" },
        { startTime: "2016-05-02T20:00:00+09:00", endTime: "2016-05-03T10:00:00+09:00" },
        { startTime: "2016-05-03T20:00:00+09:00", endTime: "2016-05-04T10:00:00+09:00" },
        { startTime: "2016-05-04T20:00:00+09:00", endTime: "2016-05-05T10:00:00+09:00" },
        { startTime: "2016-05-05T20:00:00+09:00", endTime: "2016-05-06T10:00:00+09:00" },
        { startTime: "2016-05-06T20:00:00+09:00", endTime: "2016-05-07T10:00:00+09:00" },
        { startTime: "2016-05-07T00:00:00+09:00", endTime: "2016-05-09T00:00:00+09:00" },
        { startTime: "2016-05-07T20:00:00+09:00", endTime: "2016-05-08T10:00:00+09:00" },
        { startTime: "2016-05-08T20:00:00+09:00", endTime: "2016-05-09T10:00:00+09:00" },
        { startTime: "2016-05-09T20:00:00+09:00", endTime: "2016-05-10T10:00:00+09:00" },
        { startTime: "2016-05-10T20:00:00+09:00", endTime: "2016-05-11T10:00:00+09:00" }
      ]
      expect(return_add_overtime).to eq(expected_calendar_data)
    end
    # 予定が空の時
    it "is valid empty data" do
      return_add_overtime = calendar.send(:add_overtime, [])
      expected_calendar_data = [
        { startTime: "2016-04-25T20:00:00+09:00", endTime: "2016-04-26T10:00:00+09:00" },
        { startTime: "2016-04-26T20:00:00+09:00", endTime: "2016-04-27T10:00:00+09:00" },
        { startTime: "2016-04-27T20:00:00+09:00", endTime: "2016-04-28T10:00:00+09:00" },
        { startTime: "2016-04-28T20:00:00+09:00", endTime: "2016-04-29T10:00:00+09:00" },
        { startTime: "2016-04-29T20:00:00+09:00", endTime: "2016-04-30T10:00:00+09:00" },
        { startTime: "2016-04-30T00:00:00+09:00", endTime: "2016-05-02T00:00:00+09:00" },
        { startTime: "2016-04-30T20:00:00+09:00", endTime: "2016-05-01T10:00:00+09:00" },
        { startTime: "2016-05-01T20:00:00+09:00", endTime: "2016-05-02T10:00:00+09:00" },
        { startTime: "2016-05-02T20:00:00+09:00", endTime: "2016-05-03T10:00:00+09:00" },
        { startTime: "2016-05-03T20:00:00+09:00", endTime: "2016-05-04T10:00:00+09:00" },
        { startTime: "2016-05-04T20:00:00+09:00", endTime: "2016-05-05T10:00:00+09:00" },
        { startTime: "2016-05-05T20:00:00+09:00", endTime: "2016-05-06T10:00:00+09:00" },
        { startTime: "2016-05-06T20:00:00+09:00", endTime: "2016-05-07T10:00:00+09:00" },
        { startTime: "2016-05-07T00:00:00+09:00", endTime: "2016-05-09T00:00:00+09:00" },
        { startTime: "2016-05-07T20:00:00+09:00", endTime: "2016-05-08T10:00:00+09:00" },
        { startTime: "2016-05-08T20:00:00+09:00", endTime: "2016-05-09T10:00:00+09:00" },
        { startTime: "2016-05-09T20:00:00+09:00", endTime: "2016-05-10T10:00:00+09:00" },
        { startTime: "2016-05-10T20:00:00+09:00", endTime: "2016-05-11T10:00:00+09:00" }
      ]
      expect(return_add_overtime).to eq(expected_calendar_data)
    end
  end
  describe "#to_unique_event" do
    # 被らないとき
    it "is different data" do
      calendar_data = [
        { startTime: "2016-04-27T11:00:00+09:00", endTime: "2016-04-27T12:00:00+09:00" },
        { startTime: "2016-04-27T13:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00" }
      ]
      return_unique_event = calendar.send(:to_unique_event, calendar_data)
      expected_calendar_data = [
        { startTime: "2016-04-27T11:00:00+09:00", endTime: "2016-04-27T12:00:00+09:00" },
        { startTime: "2016-04-27T13:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00" }
      ]
      expect(return_unique_event).to eq(expected_calendar_data)
    end
    # 同じデータがあるとき
    it "is same data" do
      calendar_data = [
        { startTime: "2016-04-27T11:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00" },
        { startTime: "2016-04-27T11:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00" }
      ]
      return_unique_event = calendar.send(:to_unique_event, calendar_data)
      expected_calendar_data = [
        { startTime: "2016-04-27T11:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00" },
      ]
      expect(return_unique_event).to eq(expected_calendar_data)
    end
    # 前に重なるとき
    it "is overlaped with the front" do
      calendar_data = [
        { startTime: "2016-04-27T11:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00" },
        { startTime: "2016-04-27T13:00:00+09:00", endTime: "2016-04-27T16:00:00+09:00" }
      ]
      return_unique_event = calendar.send(:to_unique_event, calendar_data)
      expected_calendar_data = [
        { startTime: "2016-04-27T11:00:00+09:00", endTime: "2016-04-27T16:00:00+09:00" },
      ]
      expect(return_unique_event).to eq(expected_calendar_data)
    end
    # 後ろに重なるとき
    it "is overlaped with the end" do
      calendar_data = [
        { startTime: "2016-04-27T11:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00" },
        { startTime: "2016-04-27T09:00:00+09:00", endTime: "2016-04-27T13:00:00+09:00" }
      ]
      return_unique_event = calendar.send(:to_unique_event, calendar_data)
      expected_calendar_data = [
        { startTime: "2016-04-27T09:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00" },
      ]
      expect(return_unique_event).to eq(expected_calendar_data)
    end
    # 前を含むとき
    it "is included the front" do
      calendar_data = [
        { startTime: "2016-04-27T11:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00" },
        { startTime: "2016-04-27T09:00:00+09:00", endTime: "2016-04-27T16:00:00+09:00" }
      ]
      return_unique_event = calendar.send(:to_unique_event, calendar_data)
      expected_calendar_data = [
        { startTime: "2016-04-27T09:00:00+09:00", endTime: "2016-04-27T16:00:00+09:00" },
      ]
      expect(return_unique_event).to eq(expected_calendar_data)
    end
    # 後ろを含むとき
    it "is included the front" do
      calendar_data = [
        { startTime: "2016-04-27T09:00:00+09:00", endTime: "2016-04-27T16:00:00+09:00" },
        { startTime: "2016-04-27T11:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00" }
      ]
      return_unique_event = calendar.send(:to_unique_event, calendar_data)
      expected_calendar_data = [
        { startTime: "2016-04-27T09:00:00+09:00", endTime: "2016-04-27T16:00:00+09:00" },
      ]
      expect(return_unique_event).to eq(expected_calendar_data)
    end
  end
  describe "#convert_free_time" do
    # 1つの予定があるとき
    it "is a data" do
      calendar_data = [
        { startTime: "2016-04-27T09:00:00+09:00", endTime: "2016-04-27T16:00:00+09:00" },
      ]
      return_free_time = calendar.send(:convert_free_time, calendar_data)
      expected_calendar_data = [
        { startTime:"2016-04-26T00:00:00+09:00", endTime: "2016-04-27T09:00:00+09:00" },
        { startTime: "2016-04-27T16:00:00+09:00", endTime: "2016-05-10T00:00:00+09:00" }
      ]
      expect(return_free_time).to eq(expected_calendar_data)
    end
    # 2つの予定があるとき
    it "is two data" do
      calendar_data = [
        { startTime: "2016-04-27T09:00:00+09:00", endTime: "2016-04-27T11:00:00+09:00" },
        { startTime: "2016-04-27T13:00:00+09:00", endTime: "2016-04-27T16:00:00+09:00" }
      ]
      return_free_time = calendar.send(:convert_free_time, calendar_data)
      expected_calendar_data = [
        { startTime:"2016-04-26T00:00:00+09:00", endTime: "2016-04-27T09:00:00+09:00" },
        { startTime:"2016-04-27T11:00:00+09:00", endTime: "2016-04-27T13:00:00+09:00" },
        { startTime: "2016-04-27T16:00:00+09:00", endTime: "2016-05-10T00:00:00+09:00" }
      ]
      expect(return_free_time).to eq(expected_calendar_data)
    end
    # 前日に予定があるとき
    it "doesn't yesterday's data" do
      calendar_data = [
        { startTime: "2016-04-25T09:00:00+09:00", endTime: "2016-04-25T11:00:00+09:00" }
      ]
      return_free_time = calendar.send(:convert_free_time, calendar_data)
      expected_calendar_data = [
        { startTime: "2016-04-26T00:00:00+09:00", endTime: "2016-05-10T00:00:00+09:00" }
      ]
      expect(return_free_time).to eq(expected_calendar_data)
    end
    # 3週間後に予定があるとき
    it "doesn't have data after three weeks" do
      calendar_data = [
        { startTime: "2016-05-17T09:00:00+09:00", endTime: "2016-05-17T11:00:00+09:00" }
      ]
      return_free_time = calendar.send(:convert_free_time, calendar_data)
      expected_calendar_data = [
        { startTime: "2016-04-26T00:00:00+09:00", endTime: "2016-05-10T00:00:00+09:00" }
      ]
      expect(return_free_time).to eq(expected_calendar_data)
    end
  end
  describe "#get_larger_than_1hour" do
    # 1時間だけ空いてるとき
    it "is free time of 1 hours" do
      calendar_data = [
        { startTime: "2016-04-27T13:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00" },
      ]
      return_larger_than_1hour = calendar.send(:get_larger_than_1hour, calendar_data)
      expected_calendar_data = [
        { startTime: "2016-04-27T13:00:00+09:00", endTime: "2016-04-27T14:00:00+09:00" },
      ]
      expect(return_larger_than_1hour).to eq(expected_calendar_data)
    end
    # 30分だけ空いてるとき
    it "is free time of 30 minutes" do
      calendar_data = [
        { startTime: "2016-04-27T13:00:00+09:00", endTime: "2016-04-27T13:30:00+09:00" },
      ]
      return_larger_than_1hour = calendar.send(:get_larger_than_1hour, calendar_data)
      expect(return_larger_than_1hour).to eq([])
    end
    # 59分59秒だけ空いてるとき
    it "is free time of 59 minutes" do
      calendar_data = [
        { startTime: "2016-04-27T13:00:00+09:00", endTime: "2016-04-27T13:59:59+09:00" },
      ]
      return_larger_than_1hour = calendar.send(:get_larger_than_1hour, calendar_data)
      expect(return_larger_than_1hour).to eq([])
    end
  end
end

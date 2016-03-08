class Api::V1::FreeTimeController < ApplicationController
  before_action :authenticate_user!

  def index
    @params = {
      current_user: current_user,
      browser_time: Time.zone.now
    }
    calendar = Calendar.new(@params)
    @set_event = calendar.index
    render json: @set_event
  end
end

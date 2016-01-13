class CalendarController < ApplicationController
  before_action :authenticate_user!
  include GoogleCalendarAPI

  def index
    @google_oauth2_info = hoge # concernのメソッドを実行
    # @google_oauth2_info = current_user.token
  end
end

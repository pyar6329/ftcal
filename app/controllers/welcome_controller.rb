class WelcomeController < ApplicationController
  include GoogleCalendarAPI

  def index
    hoge # concernのメソッドを実行
    @google_oauth2_info = current_user
  end
end

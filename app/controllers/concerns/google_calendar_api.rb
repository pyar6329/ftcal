require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/file_storage'

module GoogleCalendarAPI
  extend ActiveSupport::Concern

  def hoge
    # sample
    # https://github.com/google/google-api-ruby-client-samples/blob/master/calendar/calendar.rb
    puts "hellllllllllllllllllllllllllllllllllllllo"
    # client = Google::APIClient
    # client.authorization.access_token = current_user.token

  end
end

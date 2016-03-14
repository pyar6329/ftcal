require "rails_helper"

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  before do
    set_google_env_to_omniauth
  end

  describe "GET #google_oauth2" do
    it "redirect calendar_path" do
      get :google_oauth2
      expect(response).to redirect_to calendar_index_path
    end
  end
end

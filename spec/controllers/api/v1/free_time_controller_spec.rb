require "rails_helper"

RSpec.describe Api::V1::FreeTimeController, type: :controller do
  describe "GET #index" do
    # as test by user
    login_user

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    # ログアウトするとrootにリダイレクト
    it "redirect to root_path" do
      sign_out :user
      get :index
      expect(response).to redirect_to(root_path)
    end
  end
end

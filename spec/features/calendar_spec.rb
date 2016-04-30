require "rails_helper"
feature "Calendar" do
  given(:user) { create(:user) }
  background do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  # ログインしている場合
  feature "logined" do
    background do
      login_user_as(user)
      visit calendar_index_path
    end

    # カレンダーの内容が表示されている
    scenario "show calendar", js: true do
      # page.save_screenshot("./file.png")
      within("#calendar") do
        expect(page).to have_css(".fc-view-container")
      end
    end
  end

  # ログインしていない場合
  feature "not logined" do
    background do
      visit calendar_index_path
    end

    # トップページにリダイレクトされている
    scenario "redirect root_path", js: true do
      expect(page.has_current_path?("/")).to be_truthy
    end
  end
end

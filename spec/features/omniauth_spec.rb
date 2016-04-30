require "rails_helper"
feature "Omniauth" do
  given(:user) { create(:user) }
  background do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
    # Capybara.default_driver = :webkit
    # Capybara.default_max_wait_time = 5
    # Capybara.ignore_hidden_elements = true
  end

  # ログインの処理
  feature "login user" do
    background do
      visit root_path
    end

    # ログイン失敗の処理
    scenario "authentication fail", js: true do
      set_invalid_omniauth
      click_on "Sign_in_google"
      expect(page).to have_content "Could not authenticate you from GoogleOauth2"
    end

    # Menuのサインインをクリック時、カレンダーにリダイレクト
    scenario "redirect to /calendar when click Menu", js: true do
      set_valid_omniauth
      visit root_path
      click_on "Menu"
      click_on "sign in with Google"
      expect(page.has_current_path?("/calendar")).to be_truthy
    end

    # サインインのボタンをクリック時、カレンダーにリダイレクト
    scenario "redirect to /calendar when click Menu", js: true do
      set_valid_omniauth
      visit root_path
      click_on "Sign_in_google"
      expect(page.has_current_path?("/calendar")).to be_truthy
    end

    # ログイン成功時、サインアウトのリンクがある
    scenario "show signout link", js: true do
      login_user_as(user)
      visit root_path
      click_on "Menu"
      # page.save_screenshot("./file.png")
      expect(page).to have_link("sign out", destroy_user_session_path)
    end

    # ログイン成功時、サインインのリンクが存在しない
    scenario "show signin link", js: true do
      login_user_as(user)
      visit root_path
      click_on "Menu"
      expect(page).not_to have_link("sign in with Google", user_omniauth_authorize_path(:google_oauth2))
    end
  end

  # ログアウトの処理
  feature "logout user" do
    background do
      visit root_path
      login_user_as(user)
    end

    # ログアウト成功時、rootにリダイレクト
    scenario "redirect root_path after logout", js: true do
      logout(:user)
      expect(page.has_current_path?("/")).to be_truthy
    end

    # ログアウト成功時、サインインのリンクがある
    scenario "show signin link", js: true do
      logout(:user)
      click_on "Menu"
      expect(page).to have_link("sign in with Google", user_omniauth_authorize_path(:google_oauth2))
    end

    # ログアウト成功時、サインアウトのリンクが存在しない
    scenario "show signin link", js: true do
      logout(:user)
      click_on "Menu"
      expect(page).not_to have_link("sign out", destroy_user_session_path)
    end
  end
end

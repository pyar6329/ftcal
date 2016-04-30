module OauthMacros
  # omniauthで取得するユーザーデータの作成
  def get_omniauth_hash
    user_data = OmniAuth::AuthHash.new({
      provider: "google_oauth2",
      uid: generate(:uid),
      info: {
        name: generate(:name),
        email: generate(:email),
        first_name: generate(:first_name),
        last_name: generate(:last_name),
        image: generate(:avatar_image)
      },
      credentials: {
        token: generate(:password),
        refresh_token: generate(:password),
        expires_at: generate(:expires_at),
        expires: true
      },
      extra: {
        raw_info: {
          sub: "123456789",
          email: generate(:email),
          email_verified: true,
          name: generate(:name),
          given_name: generate(:first_name),
          family_name: generate(:last_name),
          profile: generate(:url),
          picture: generate(:avatar_image),
          gender: generate(:gender),
          birthday: "0000-06-25",
          locale: "en",
          hd: generate(:last_name)
        },
        id_info: {
          "iss" => "accounts.google.com",
          "at_hash" => generate(:password),
          "email_verified" => "true",
          "sub" => "10769150350006150715113082367",
          "azp" => "APP_ID",
          "email" => generate(:email),
          "aud" => "APP_ID",
          "iat" => 1353601026,
          "exp" => 1353604926,
          "openid_id" => generate(:url)
        }
      }
    })
    user_data
  end

  # 有効なログイン(controller_spec)
  def set_valid_omniauth_callback
    # deviseの割当て
    @request.env["devise.mapping"] = Devise.mappings[:user]

    # omniauthにgoogleをセットする
    request.env["omniauth.auth"] = get_omniauth_hash
  end

  # 有効なログイン
  def set_valid_omniauth
    # omniauthにgoogleをセットする
    OmniAuth.config.mock_auth[:google_oauth2] = get_omniauth_hash
  end

  # 無効なログイン
  def set_invalid_omniauth
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
  end

  # ログイン
  def login_user_as(user)
    login_as user, scope: :user
  end
end

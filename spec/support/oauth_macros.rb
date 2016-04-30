module OauthMacros
  # omniauthで取得するユーザーデータの作成
  # def get_omniauth_hash
  #   user_data = OmniAuth::AuthHash.new({
  #     "provider" => "google_oauth2",
  #     "uid" => generate(:uid),
  #     "info" => {
  #       "name" => generate(:name),
  #       "email" => generate(:email)
  #     },
  #     "credentials" => {
  #       "token" => generate(:password),
  #       "refresh_token" => generate(:password),
  #       "expires_at" => generate(:expires_at),
  #       "expires" => "true"
  #     }
  #   })
  #   user_data
  # end

  def get_omniauth_hash
    user_data = OmniAuth::AuthHash.new({
      :provider => "google_oauth2",
      :uid => "123456789",
      :info => {
          :name => "John Doe",
          :email => "john@company_name.com",
          :first_name => "John",
          :last_name => "Doe",
          :image => "https://lh3.googleusercontent.com/url/photo.jpg"
      },
      :credentials => {
          :token => "token",
          :refresh_token => "another_token",
          :expires_at => 1354920555,
          :expires => true
      },
      :extra => {
          :raw_info => {
              :sub => "123456789",
              :email => "user@domain.example.com",
              :email_verified => true,
              :name => "John Doe",
              :given_name => "John",
              :family_name => "Doe",
              :profile => "https://plus.google.com/123456789",
              :picture => "https://lh3.googleusercontent.com/url/photo.jpg",
              :gender => "male",
              :birthday => "0000-06-25",
              :locale => "en",
              :hd => "company_name.com"
          },
          :id_info => {
              "iss" => "accounts.google.com",
              "at_hash" => "HK6E_P6Dh8Y93mRNtsDB1Q",
              "email_verified" => "true",
              "sub" => "10769150350006150715113082367",
              "azp" => "APP_ID",
              "email" => "jsmith@example.com",
              "aud" => "APP_ID",
              "iat" => 1353601026,
              "exp" => 1353604926,
              "openid_id" => "https://www.google.com/accounts/o8/id?id=ABCdfdswawerSDFDsfdsfdfjdsf"
          }
      }
      # provider: "google_oauth2",
      # uid: generate(:uid),
      # info: {
      #   name: generate(:name),
      #   email: generate(:email)
      # },
      # credentials: {
      #   token: generate(:password),
      #   refresh_token: generate(:password),
      #   expires_at: generate(:expires_at),
      #   expires: true
      # }
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
    # @request.env["devise.mapping"] = Devise.mappings[:user]
    # # user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
    # sign_in user
    # user
  end
end

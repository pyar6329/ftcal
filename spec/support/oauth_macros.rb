module OauthMacros
  def set_google_env_to_omniauth(user = {})
    # deviseの割当て
    @request.env["devise.mapping"] = Devise.mappings[:user]

    # パラメータがない場合、デフォルトの値を設定する
    user[:provider] = "google_oauth2" if user[:provider].nil?
    user[:email] = generate(:email) if user[:email].nil?
    user[:uid] = generate(:uid) if user[:uid].nil?
    user[:name] = generate(:name) if user[:name].nil?
    user[:token] = generate(:password) if user[:token].nil?
    user[:refresh_token] = generate(:password) if user[:refresh_token].nil?
    user[:expires_at] = generate(:expires_at) if user[:expires_at].nil?
    user[:expires] = true if user[:expires].nil?

    # omniauthにgoogleをセットする
    request.env["omniauth.auth"] = OmniAuth::AuthHash.new({
      provider: user[:provider],
      uid: user[:uid],
      info: {
        name: user[:name],
        email: user[:email]
      },
      credentials: {
        token: user[:token],
        refresh_token: user[:refresh_token],
        expires_at: user[:expires_at],
        expires: user[:expires]
      }
    })
  end
end

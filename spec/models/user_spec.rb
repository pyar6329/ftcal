require "rails_helper"

RSpec.describe User, type: :model do
  # 以下のカラムが全部があれば有効な状態であること
  # email :string
  # encrypted_password :string
  # provider :string
  # uid :string
  # name :string
  # token :string
  # expires_at :integer
  # expires :boolean
  # refresh_token :string
  it "is valid with email, encrypted_password, provider, uid, name, token, expires_at, expires and refresh_token"

  # メールがなければ無効な状態であること
  it "is invalid without a email"

  # パスワードがなければ無効な状態であること
  it "is invalid without a encrypted_password"

  # プロバイダがなければ無効な状態であること
  it "is invalid without a provider"

  # ユーザーIDがなければ無効な状態であること
  it "is invalid without a uid"

  # 名前がなければ無効な状態であること
  it "is invalid without a name"

  # トークンがなければ無効な状態であること
  it "is invalid without a token"

  # 失効日がなければ無効な状態であること
  it "is invalid without a expires_at"

  # 失効状態がなければ無効な状態であること
  it "is invalid without a expires"

  # 更新用トークンがなければ無効な状態であること
  it "is invalid without a refresh_token"
end

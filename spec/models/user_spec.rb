require "rails_helper"

RSpec.describe User, type: :model do
  # 正しいユーザーを作成
  let(:correct_user) { build(:user) }

  describe "with validation" do
    # 以下のカラムが全部があれば有効な状態であること
    # email :string
    # password :string
    # provider :string
    # uid :string
    # name :string
    # token :string
    # expires_at :integer
    # expires :boolean
    it "is valid with email, password, provider, uid, name, token, expires_at, expires" do
      expect(correct_user).to be_valid
    end

    # メールアドレスがなければ無効な状態であること
    it "is invalid without a email" do
      # user = build(:user, email: nil)
      # user.valid?
      # expect(user.errors[:email]).to include("can't be blank")
      # user = build(:user)
      # expect(user).not_to allow_value(nil).for(:email)
      is_expected.to validate_presence_of(:email)
    end

    # パスワードがなければ無効な状態であること
    it "is invalid without a password" do
      is_expected.to validate_presence_of(:password)
    end

    # プロバイダがなければ無効な状態であること
    it "is invalid without a provider" do
      is_expected.to validate_presence_of(:provider)
    end

    # ユーザーIDがなければ無効な状態であること
    it "is invalid without a uid" do
      is_expected.to validate_presence_of(:uid)
    end

    # 名前がなければ無効な状態であること
    it "is invalid without a name" do
      is_expected.to validate_presence_of(:name)
    end

    # トークンがなければ無効な状態であること
    it "is invalid without a token" do
      is_expected.to validate_presence_of(:token)
    end

    # 失効日がなければ無効な状態であること
    it "is invalid without a expires_at" do
      is_expected.to validate_presence_of(:expires_at)
    end

  # 失効状態がなければ無効な状態であること
    it "is invalid without a expires" do
      is_expected.to validate_presence_of(:expires)
    end

    # メールアドレスが重複していないこと(大文字小文字は分けない)
    it "is invalid with a duplicate email" do
      is_expected.to validate_uniqueness_of(:email).case_insensitive
    end

    # プロバイダとユーザーIDの組み合わせが重複していないこと
    it "is invalid with a duplicate provider and uid" do
      is_expected.to validate_uniqueness_of(:provider).scoped_to(:uid)
    end
  end
end

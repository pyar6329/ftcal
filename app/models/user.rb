class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :omniauthable

  def self.find_for_google_oauth2(auth)
    user = User.where(email: auth.info.email).first

    # tokenが失効時、ユーザー情報を更新
    unless auth.credentials.expires
      user.update(name: auth.info.name,
                  provider: auth.provider,
                  uid: auth.uid,
                  email: auth.info.email,
                  token: auth.credentials.token,
                  password: Devise.friendly_token[0, 20],
                  expires_at: auth.credentials.expires_at,
                  expires: auth.credentials.expires
                 )
    end
    # ユーザーが居ない場合、作成する
    unless user
      user = User.create(name: auth.info.name,
                         provider: auth.provider,
                         uid: auth.uid,
                         email: auth.info.email,
                         token: auth.credentials.token,
                         password: Devise.friendly_token[0, 20],
                         expires_at: auth.credentials.expires_at,
                         expires: auth.credentials.expires
                         )
    end
    user
  end
end

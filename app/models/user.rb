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

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :provider,
            presence: true,
            uniqueness: { scope: [:uid] }

  validates_presence_of :password,
                        :uid,
                        :name,
                        :token,
                        :expires_at,
                        :expires

  def self.find_for_google_oauth2(auth)
    user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    user.attributes = {
      email: auth.info.email,
      password: Devise.friendly_token[0, 20],
      provider: auth.provider,
      name: auth.info.name,
      uid: auth.uid,
      token: auth.credentials.token,
      expires_at: auth.credentials.expires_at,
      expires: auth.credentials.expires,
      refresh_token: auth.credentials.refresh_token.present? ? auth.credentials.refresh_token : ""
    }
    user.save if user.changed?
    user
  end
end

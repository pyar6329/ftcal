FactoryGirl.define do
  factory :user, class: User do
    email { generate :email }
    password "foobartest"
    password_confirmation "foobartest"
    provider "google_oauth2"
    uid { generate :uid }
    name { generate :name }
    token { generate :password }
    expires_at { generate :expires_at }
    expires true
    refresh_token { generate :password }
    factory :admin
  end
end

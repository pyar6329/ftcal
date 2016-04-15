require "securerandom"
FactoryGirl.define do
  sequence(:email) { FFaker::Internet.email }
  sequence(:name) { FFaker::Name.name }
  sequence(:password) { FFaker::Internet.password }
  sequence(:uid) { rand(10**20..10**21).to_s }
  sequence(:expires_at) { SecureRandom.hex(3).hex }
end

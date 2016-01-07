FactoryGirl.define do
  factory :admin, class: User do
    id 60000
    email "testadmin@test.com"
    password "foobartest"
    password_confirmation "foobartest"
  end

  factory :user, class: User do
    id 60001
    email "testuser@test.com"
    password "foobartest"
    password_confirmation "foobartest"
  end

end

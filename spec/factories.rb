Factory.define :user do |f|
  f.sequence(:email) { |n| "foo#{n}@example.com" }
  first_name 'Kabra'
  last_name 'Darf'
  kgs_names 'kabradarf'
  username 'kabradarf'
  f.password "secret"
end
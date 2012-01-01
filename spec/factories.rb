Factory.define :user do |obj|
  obj.sequence(:email) { |n| "foo#{n}@example.com" }
  obj.first_name 'Kabra'
  obj.last_name 'Darf'
  obj.kgs_names 'kabradarf'
  obj.username 'kabradarf'
  obj.password "secret"
end

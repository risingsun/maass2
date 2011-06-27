Factory.define :user do |u|
  u.sequence(:email) {|n| "amit#{n}@gmail.com"}
  u.password "abcdefg"
  u.password_confirmation "abcdefg"
  u.sequence(:login) {|n| "amit#{n}"}
end
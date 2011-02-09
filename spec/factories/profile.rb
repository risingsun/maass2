Factory.define :profile do |p|
  p.user {|p| p.association(:user)}
end
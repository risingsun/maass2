Factory.define :comment do |c|
  c.profile {|u| u.association(:profile)}
  c.association :commentable, :factory => :blog
  c.comment "Hello"
end
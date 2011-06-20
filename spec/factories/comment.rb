Factory.define :comment do |c|
  c.profile {|u| u.association(:profile)}
  c.association :commentable, :factory => :blog
  c.comment "Hello"
end

Factory.define :profile_comment, :class => Comment do |c|
  c.profile {|u| u.association(:profile)}
  c.association :commentable, :factory => :profile
  c.comment "Hello"
end
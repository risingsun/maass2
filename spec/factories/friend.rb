Factory.define :friend do |f|
  f.association :inviter, :factory => :profile
  f.association :invited, :factory => :profile
  f.status "1"
end

Factory.define :follower, :class => Friend do |f|
  f.association :inviter, :factory => :profile
  f.association :invited, :factory => :profile
  f.status "0"
end
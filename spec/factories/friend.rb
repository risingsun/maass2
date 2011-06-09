Factory.define :friend do |f|
  f.association :inviter, :factory => :profile
  f.association :invited, :factory => :profile
  f.status true
end

Factory.define :follower, :class => Friend do |f|
  f.association :inviter, :factory => :profile
  f.association :invited, :factory => :profile
  f.status false
end
Factory.define :forum_post do |f|
  f.body "my forum post"
  f.association :owner, :factory => :profile
  f.association :topic, :factory => :forum_topic
end
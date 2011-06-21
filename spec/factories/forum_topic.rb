Factory.define :forum_topic do |f|
  f.title "first forum topic"
  f.forum {|p| p.association(:forum)}
  f.association :owner, :factory=> :profile
end
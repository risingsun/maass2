Factory.define :blog do |b|
  b.profile {|p| p.association(:profile)}
  b.title "hi"
  b.body "my first blog"
  b.is_sent true
  b.public true
  b.comments_count "1"
end
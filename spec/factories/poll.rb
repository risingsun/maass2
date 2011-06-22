Factory.define :poll do |p|
  p.question "hi how r u all"
  p.profile {|p| p.association(:profile)}
  p.public false
  p.status true
  p.votes_count "0"
end
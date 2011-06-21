Factory.define :poll_response do |p|
  p.profile {|u| u.association(:profile)}
  p.poll {|u| u.association(:poll)}
  p.poll_option {|u| u.association(:poll_option)}
end
Factory.define :poll_option do |p|
  p.option "fine"
  p.poll {|p| p.association(:poll)}
  p.poll_responses_count "0"
end
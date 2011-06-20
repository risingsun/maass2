Factory.define :event do |e|
  e.marker {|m| m.association(:marker)}
  e.start_date DateTime.now
  e.end_date DateTime.now
  e.title "party"
  e.place "jaipur"
  e.description "please come"
  e.comments_count "1"
end
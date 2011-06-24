Factory.define :nomination do |n|
  n.profile {|p| p.association(:profile)}
  n.contact_details "m. i. road, jaipur"
  n.occupational_details "ruby on rails developer"
  n.reason_for_nomination "trying"
  n.suggestions "text here.. text here.."
end
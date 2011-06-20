Factory.define :invitation do |i|
  i.profile {|p| p.association(:profile)}
  i.email "amit@gmail.com"
end
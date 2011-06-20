Factory.define(:feedback) do |f|
  f.profile {|p| p.association(:profile)}
  f.name "amit"
  f.email "amit@gmail.com"
  f.subject "hello"
  f.message "nice application"
end
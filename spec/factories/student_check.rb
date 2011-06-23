Factory.define :student_check do |s|
  s.name "amit kumar gupta"
  s.first_name "amit"
  s.middle_name "kumar"
  s.last_name "gupta"
  s.year "2011"
  s.profile {|p| p.association(:profile)}
  s.e_mail_1 "amit1@gmail.com"
  s.e_mail_2 "amit2@gmail.com"
end
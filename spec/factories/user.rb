Factory.define :user do |u|
  u.email "pariharkirti24@gamil.com"
  u.password "123456"
  u.password_confirmation "123456"
  u.login "kirti"
  u.humanizer_question_id "Two plus two?"
  u.humanizer_answer "four"
end

Factory.define :account do |a|
  a.user_id "1"
  a.default_permission "null"
  a.association :user
end

Factory.define :permission do |p|
  p.account_id "1"
  p.website "x"
  p.blog "x"
  p.about_me "x"
  p.gtalk_name "x"
  p.location"x"
  p.email "x"
  p.date_of_birth "x"
  p.anniversary_date "x"
  p.relationship_status "x"
  p.spouse_name "x"
  p.gender "x"
  p.activities "x"
  p.yahoo_name "x"
  p.skype_name "x"
  p.educations "x"
  p.work_informations "x"
  p.delicious_name "x"
  p.twitter_username "x"
  p.msn_username "x"
  p.linkedin_name "x"
  p.address "x"
  p.landline "x"
  p.mobile "x"
  p.marker "x"
end

Factory.define :notification do |n|
  n.account_id "1"
  n.news_notification "true"
  n.event_notification "true"
  n.message_notification "true"
  n.blog_comment_notification "true"
  n.profile_comment_notification "true"
  n.follow_notification "true"
  n.delete_friend_notification "true"
end

Factory.define :profile do |p|
  p.user_id "1"
  p.first_name "kirti"
  p.last_name "parihar"
  p.title "x"
  p.blood_group "x"
  p.house_name "x"
  p.date_of_birth "x"
  p.relationship_status "x"
  p.aniversary_date "x"
  p.spouse_name "x"
  p.professional_qualification "x"
  p.about_me "x"
  p.activities "x"
  p.location "x"
  p.address_line1 "x"
  p.address_line2 "x"
  p.city "x"
  p.postal_code "x"
  p.country "x"
  p.state "x"
  p.landline "x"
  p.mobile "x"
  p.status_message "click here to set status"
  p.website "x"
  p.blog "x"
  p.flicker_username "x"
  p.linkedin_name "x"
  p.twitter_username "x"
  p.aim_name "x"
  p.msn_username "x"
  p.yahoo_name "x"
  p.gtalk_name "x"
  p.skype_name "x"
  p.delicious_name "x"
  p.icon_file_name "x"
end

Factory.define :blog do |b|
  b.profile_id "1"
  b.title "hi"
  b.body "my first blog"
  b.is_sent "true"
end

Factory.define :work do |b|
  b.profile_id "1"
  b.occupation "trainee"
  b.industry "web design"
  b.company_name "rising sun tech"
  b.company_website "risingsuntech.com"
  b.job_description "developer"
end

Factory.define :education do |b|
  b.profile_id "1"
  b.education_from_year "2006"
  b.education_to_year "2008"
  b.institution "MCA"
  b.association :profile
end

Factory.define :polls do |p|
  p.profile_id "1"
  p.question "hi how r u all"
  p.public "false"
  p.status "true"
  p.votes_count "false"
end
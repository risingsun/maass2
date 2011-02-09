Factory.define :user do |u|
  u.email "pariharkirti24@gamil.com"
  u.password "123456"
  u.password_confirmation "123456"
  u.login_name "kirti"
  u.first_name "kirti"
  u.last_name "parihar"
  u.humanizer_question_id "Two plus two?"
  u.humanizer_answer "four"
end

Factory.define :account do |a|
  a.user_id "1"
  a.default_permission "null"
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
  n.news_notification
  n.event_notification
  n.message_notification
  n.blog_comment_notification
  n.profile_comment_notification
  n.follow_notification
  n.delete_friend_notification
end

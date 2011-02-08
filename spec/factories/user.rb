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

Factory.define :account do |u|
  u.user_id "1"
  u.default_permission "null"
end

Factory.define :permission do |u|
  u.account_id "1"
  u.website "x"
  u.blog "x"
  u.about_me "x"
  u.gtalk_name "x"
  u.location"x"
  u.email "x"
  u.date_of_birth "x"
  u.anniversary_date "x"
  u.relationship_status "x"
  u.spouse_name "x"
  u.gender "x"
  u.activities "x"
  u.yahoo_name "x"
  u.skype_name "x"
  u.educations "x"
  u.work_informations "x"
  u.delicious_name "x"
  u.twitter_username "x"
  u.msn_username "x"
  u.linkedin_name "x"
  u.address "x"
  u.landline "x"
  u.mobile "x"
  u.marker "x"
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

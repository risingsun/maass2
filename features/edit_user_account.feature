#Feature: Edit User Account
#    In order to edit user account
#    As a user
#    I want to edit my account information
#
#    Scenario: Edit Permissions
#      Given I am a valid user
#      And I sign in with valid data
#      When I follow "Edit Account"
#      Then I should see "Permissions"
#      And I choose "account[permission_attributes][website]"
#      And I choose "account[permission_attributes][blog]"
#      And I choose "account[permission_attributes][about_me]"
#      And I choose "account[permission_attributes][gtalk_name]"
#      And I choose "account[permission_attributes][location]"
#      And I choose "account[permission_attributes][email]"
#      And I choose "account[permission_attributes][date_of_birth]"
#      And I choose "account[permission_attributes][anniversary_date]"
#      And I choose "account[permission_attributes][relationship_status]"
#      And I choose "account[permission_attributes][spouse_name]"
#      And I choose "account[permission_attributes][gender]"
#      And I choose "account[permission_attributes][activities]"
#      And I choose "account[permission_attributes][yahoo_name]"
#      And I choose "account[permission_attributes][skype_name]"
#      And I choose "account[permission_attributes][educations]"
#      And I choose "account[permission_attributes][work_informations]"
#      And I choose "account[permission_attributes][delicious_name]"
#      And I choose "account[permission_attributes][twitter_username]"
#      And I choose "account[permission_attributes][msn_username]"
#      And I choose "account[permission_attributes][linkedin_name]"
#      And I choose "account[permission_attributes][address]"
#      And I choose "account[permission_attributes][landline]"
#      And I choose "account[permission_attributes][mobile]"
#      And I choose "account[permission_attributes][marker]"
#      Then I press "Update permissions"
#
#    Scenario: Edit Notifications
#      Given I am a valid user
#      And I sign in with valid data
#      When I follow "Edit Account"
#      Then I should see "Notification "
#      And the "account[notification_attributes][news_notification][]" checkbox should not be checked
#      And the "account[notification_attributes][event_notification][]" checkbox should not be checked
#      And the "account[notification_attributes][message_notification][]" checkbox should not be checked
#      And the "account[notification_attributes][blog_comment_notification][]" checkbox should not be checked
#      And the "account[notification_attributes][profile_comment_notification][]" checkbox should not be checked
#      And the "account[notification_attributes][follow_notification][]" checkbox should not be checked
#      And the "account[notification_attributes][delete_friend_notification][]" checkbox should not be checked
#      Then I check "account[notification_attributes][news_notification][]"
#      And I check "account[notification_attributes][event_notification][]"
#      And I check "account[notification_attributes][message_notification][]"
#      And I check "account[notification_attributes][blog_comment_notification][]"
#      And I check "account[notification_attributes][profile_comment_notification][]"
#      And I check "account[notification_attributes][follow_notification][]"
#      And I check "account[notification_attributes][delete_friend_notification][]"
#      Then I press "Update permissions"
#
#    Scenario: Change Password
#      Given I am a valid user
#      And I sign in with valid data
#      When I follow "Edit Account"
#      Then I should see "Password "
#      And I fill in the following:
#         | Current password       | value |
#         | New Password           | value |
#         | Password confirmation  | value |
#      Then I press "Password Change"
#
#    Scenario: Change Email
#      Given I am a valid user
#      And I sign in with valid data
#      When I follow "Edit Account"
#      Then I should see "Email"
#      And I should see "current email"
#      And I fill in the following:
#         |user[email]    | kirti@gmail.com |
#      Then I press "Email Change"
#
#    Scenario: Set Default Permissions
#      Given I am a valid user
#      And I sign in with valid data
#      When I follow "Edit Account"
#      Then I should see "Default Permission"
#      And I select "Everyone" from "Default Permission"
#      Then I press "Set Default"
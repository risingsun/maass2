Feature: Sign Up
    In order to perform sign up
    As a user
    I want to register a new account

  Scenario: sign up
    Given I am not authenticated
    And I am on the home page
    When I follow "Sign Up"
    And I fill in the following:
        |Email                 | pariharkirti24@gmail.com |
        |Password              | 123456 |
        |Password confirmation | 123456 |
        |Login name            | kirti  |
        |First name            | kkkkk |
    And I press "Sign Up"
    Then I should see "You have signed up successfully. If enabled, a confirmation was sent to your e-mail."
    And I should be on the home page

  Scenario: create profile when user profile does not exist
    Given I am a valid user
    And I sign in with valid data
    And no user profile exists
    When I follow "Edit Profile"
    Then show me the page
#    Then I fill in the following:
#        |Status     | hello |
#    And I press "Update"
#    And show me the page
#
##  Scenario: Update Status
##    Given I am on the edit profile page
##    And I fill in the following:
##        |Status     | hello |
##    When I press "Update"
##    And show me the page
#
#    Scenario: Update General info
#      Given I am a valid user
#      And I sign in with valid data
#      When I follow "Edit Profile"
#      Then I fill in the following:
#         |Login name  | kirti |
#         |Title       | miss  |
#         |First name  | kirti |
#         |Middle name | singh |
#         |Last name   | parihar|
#      And I press "Update"
#      And show me the page
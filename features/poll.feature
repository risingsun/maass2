Feature: Poll
    In order to vote into the system
    As a user
    I want to login in my account with the system

 Scenario: New poll Info
    Given I am on the home page
    And I am a valid user
    And I sign in with valid data
    Then I should be on the home page
    When I follow "My Polls"
    And show me the page
    Then I should see "New Poll" 
    And I fill in the following:
        |poll_question                                    | hi how r u all     |
        |poll[poll_options_attributes][0][option]         | fine               |
    Then I press "Create Poll"
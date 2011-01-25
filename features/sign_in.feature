Feature: Sign In
    In order to log into the system
    As a user
    I want to login in my account with the system

 Scenario: Sign In with Valid Data
    Given I am on the sign in page
    And I am a valid user
    And I sign in with valid data
    Then I should be on the home page
   
    
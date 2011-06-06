Feature: Sign Up
    In order to perform sign up
    As a user
    I want to register a new account

  Scenario: sign up
    Given I am not authenticated
    And I am on the home page
    When I follow "Signup"
    And I fill in the following:
        | Email                           | amitk12@gmail.com |
        | user_password                   | abcdefg |
        | user_password_confirmation      | abcdefg |
        | Login                           | amitkkk   |
        | First Name                      | Amit   |
        | Last Name                       | Gupta  |
    And I select "Male" from "Gender"
    And I select "2011" from "Group"
    And I check "user_terms_of_service"
    And I press "submit"
    Then show me the page
    And I should be on the sign in page
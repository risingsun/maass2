Feature: Sign Up
    In order to perform sign up
    As a user
    I want to register a new account

    Scenario: sign up
        Given I am on the sign up page
        And I fill in the following:
            |Email                 | pariharkirti24@gmail.com |
            |Password              | 123456 |
            |Password confirmation | 123456 |
            |Login name            | kirti  |
            |  First name     |  kkkkk     |
        When I press "Sign Up"
        And show me the page
        Then I should see "You have signed up successfully. If enabled, a confirmation was sent to your e-mail."
#        And I should be on the home page

       
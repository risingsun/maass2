Feature: Create Blog
    In order to create a blog
    As a user
    I want to create a new blog

Scenario: Create a new Blog
    Given I am a valid user
    And I sign in with valid data
    And show me the page
    When I follow "My Blogs"
    

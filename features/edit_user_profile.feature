Feature: Edit User Profile
    In order to edit user profile
    As a user
    I want to edit my profile

   Scenario: Update profile status
     Given I am a valid user
     And I sign in with valid data
     When I follow "Edit Profile"
     Then show me the page
     And I should see "click here to set status"
     And I fill in the following:
        |status               | hello              |
     Then I press "Update"

   Scenario: Edit General Info
     Given I am a valid user
     And I sign in with valid data
     When I follow "Edit Profile"
     Then I should see "General Info"
     And I fill in the following:
        |Login                           | kirti              |
        |First name                          | kirti              |
        |Middle name                         | singh              |
        |Last name                           | parihar            |
        |Maiden name                    | parihar            |
#        |Date of birth                       | 12/12/88           |
#        |Aniversary date                   | 12/12/99           |
        |House name                          | parihar            |
        |Spouse name                         | parihar            |
        |Professional qualification          | parihar            |
        |About me                            | parihar            |
        |activities                          | parihar            |
     And I select "Ms." from "Title"
     And I select "Female" from "Gender"
     And I select "Teacher" from "Group"
     And I select "O+" from "Blood group"
     And I select "single" from "Relationship status"
     Then I press "Update"

   Scenario: Edit Contact Info
     Given I am a valid user
     And I sign in with valid data
     When I follow "Edit Profile"
     Then I should see "Contact Info"
     And I fill in the following:
        |Location                            | jaipur             |
        |Address line1                       | vidhyadhar nagar   |
        |Address line2                       | nagori gate        |
        |City                                | jaipur             |
        |Postal code                         | 342001             |
        |Landline                            | 01412334323        |
        |Mobile                              | 9509801383         |
     And I select "India" from "Country"
     And I select "Rajasthan" from "State"
     Then I press "Update"

  Scenario: Edit Web Info
     Given I am a valid user
     And I sign in with valid data
     When I follow "Edit Profile"
     Then I should see "Web Info"
     And I fill in the following:
        |Website                             | X                  |
        |Blog                                | Y                  |
        |Flicker                             | Z                  |
        |LinkedIn Public URL                 | X                  |
        |Twitter                             | X                  |
        |AIM                                 | X                  |
        |MSN                                 | X                  |
        |Yahoo UserId                        | X                  |
        |Gtalk                               | X                  |
        |Skype                               | X                  |
        |delicious name                      | X                  |
     Then I press "Update"

  Scenario: Edit Education Info
       Given I am a valid user
       And I sign in with valid data
       When I follow "Edit Profile"
       Then I should see "Education Info"
       And I select "1995" from "From Year"
       And I select "2000" from "To Year"
       And I fill in the following:
         |Institution                        | X                  |
       Then I press "Update"

  Scenario: Edit Work Info
     Given I am a valid user
     And I sign in with valid data
     When I follow "Edit Profile"
     Then I should see "Work Info"
     And I fill in the following:
      |Occupation                          | x                  |
      |Industry                            | X                  |
      |Company name                        | X                  |
      |Company website                     | X                  |
      |Job description                     | X                  |
     Then I press "Update"

  Scenario: Upload Icon
     Given I am a valid user
     And I sign in with valid data
     When I follow "Edit Profile"
     Then I should see "Upload icon"
     And I attach the file "Home/Downloads/picture.jpg" to "Upload your Icon (<=5Mb)"
     Then I press "Update"

Given /^I am not authenticated$/ do
  visit "/users/sign_out"
end

Given /^I am a valid user$/ do
  @user = Factory(:user)
end

Given /^no user profile exists$/ do
  @user.profile.should be_nil
end

Then /^I select from:$/ do |table|
#      select("Rajasthan", :from => "State")
end

Then /^I attach the file to:$/ do |table|
#  # table is a Cucumber::Ast::Table
#  pending # express the regexp above with the code you wish you had
end


#Then /^I should be signed in$/ do
#  email = @user.email
#  password = @user.password
#  When %{I fill in "Email" with "#{email}"}
#  And %{I fill in "Password" with "#{password}"}
#  When %{I press "Sign In"}
#  Then %{I should see "Signed in successfully"}
#  @current_user = User.find_by_id!(@user)
#end

Given /^I sign in with valid data$/ do
  email = @user.email
  password = @user.password
  visit "/users/sign_in"
  When %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  When %{I press "Sign In"}
  Then %{I should see "Signed in successfully."}
  @current_user = User.find_by_id!(@user)
end

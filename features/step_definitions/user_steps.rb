Given /^I am a valid user$/ do
  @user = Factory(:user)
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
  When %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  When %{I press "Sign In"}
  Then %{I should see "Signed in successfully"}
  @current_user = User.find_by_id!(@user)
end

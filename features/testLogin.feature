Feature: Login to My Webapp
 
Scenario: Fill in a Login Form        
 Given I visit a login form
 Then I will enter my username "tester@crossbrowsertesting.com"
 Then I enter my password "test123"
 Then I will click the login button
 Then I should see "You are now logged in!"



Given(/^I visit a login form$/) do
    visit 'http://crossbrowsertesting.github.io/login-form.html'
end

Then(/^I will enter my username "(.*?)"$/) do |searchText|
    fill_in 'username', :with => searchText
end

Then(/^I enter my password "(.*?)"$/) do |expectedText|
    fill_in 'password', :with => expectedText
end

Then(/^I will click the login button$/) do
    click_button('Login')
end

Then(/^I should see "(.*?)"$/) do |expectedText|
    assert page.has_content?(expectedText)
end

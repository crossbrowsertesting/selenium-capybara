# Selenium Testing with CBT and Capybara

[Capybara](https://github.com/teamcapybara/capybara) is a common testing framework for testing web applications in Ruby. In this example, we'll get up to speed running our Capybara tests in the cloud using CBT's VM/Device lab. First let's get the necessary dependencies intsalled. Its easiest to do so with [Gem](https://rubygems.org/):

```
gem install cucumber
gem install capybara
```

We'll also need [Selenium](http://www.seleniumhq.org/):

```
gem install selenium-webdriver
```

Lastly, we'll need [Rest-Client](https://github.com/rest-client/rest-client) so we can make RESTful calls to our API:

```
gem install rest-client
```

Now we're ready to get started. From your terminal, navigate to a new directory where we can start writing our tests. The first thing you'll need to do is run the following command:

```
cucumber --init
```

This will create a features directory where we can place our step definitions. I'd suggest cloning this repository so you can make use of the local connection setup methods already written. To setup the CBT environment, create a file called env.rb, and copy the below code into it:

```
require 'selenium/webdriver'
require 'capybara/cucumber'
#require_relative 'tunnel'
username = "YOUR_USERNAME_HERE".sub('@', '%40') # your username
authkey = "YOUR_AUTHKEY_HERE" # your authkey
url = "http://#{username}:#{authkey}@hub.crossbrowsertesting.com/wd/hub"

#start_tunnel(username,authkey)

Capybara.register_driver 'selenium_remote_cctest'.to_sym do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.new
  caps['name'] = 'Selenium Test Example'
  caps['build'] = '1.0'
  # request the latest version of firefox by default
  # To specify a version add caps['version'] = 'desired version'
  caps['browserName'] = 'Firefox'
  caps['platform'] = 'Mac OSX 10.12'
  caps['screen_resolution'] = '1366x768'
  caps['record_video'] = 'true'
  caps['record_network'] = 'true'   

  Capybara::Selenium::Driver.new(app,
                                 :browser => :remote,
                                 :url => url,
                                 :desired_capabilities => caps)
end

Capybara.default_driver = 'selenium_remote_cctest'.to_sym
Capybara.app_host = "http://www.yourawesomewebsite.com"
Capybara.run_server = false
```

The above code will allow us to start a RemoteWebDriver pointed at our hub. Be sure to change the file to contain your username and the authkey found on the [Selenium Dashboard](https://app.crossbrowsertesting.com/selenium/run) in our app. 
Also note that lines 3 and 8 (`require_relative 'tunnel'` and `start_tunnel(username,authkey)`) are commented out. If you need to start a local connection to test behind your firewall, please refer to the section labeled "Local Connection" at the bottom of this document after you have set up your tests.

From here, we can begin to create our test features. If you're still in the features directory, create a new file called testLogin.feature. Here is where we'll create the steps for our test case in Cucumber's plain english style [Gherkin language](https://github.com/cucumber/cucumber/wiki/Gherkin). Your file should look something like this:

```
Feature: Login to My Webapp
 
Scenario: Fill in a Login Form        
 Given I visit a login form
 Then I will enter my username "tester@crossbrowsertesting.com"
 Then I enter my password "test123"
 Then I will click the login button
 Then I should see "You are now logged in!"
```

If we back up one directory (to the directory above 'features') and try to run our tests by entering the command `cucumber`, we should see some method stubs provided automatically by Cucumber:

```
Feature: Login to My Webapp

  Scenario: Fill in a Login Form                                   # features/testLogin.feature:3
    Given I visit a login form                                     # features/testLogin.feature:4
    Then I will enter my username "tester@crossbrowsertesting.com" # features/testLogin.feature:5
    Then I enter my password "test123"                             # features/testLogin.feature:6
    Then I will click the login button                             # features/testLogin.feature:7
    Then I should see "You are now logged in!"                     # features/testLogin.feature:8

1 scenario (1 undefined)
5 steps (5 undefined)
0m0.006s

You can implement step definitions for undefined steps with these snippets:

Given(/^I visit a login form$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I will enter my username "([^"]*)"$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I enter my password "([^"]*)"$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I will click the login button$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see "([^"]*)"$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end
```

Next, let's navigate to the step_definitions directory created by Cucumber. Here we'll place the methods stubs Cucumber suggested, and we'll fill in the necessary functional code to perform our test:

```
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
```

If we back up to the directory above 'features' and run our tests again using `cucumber`, we should see a successful test-run:

```
Feature: Login to My Webapp

  Scenario: Fill in a Login Form                                   # features/testLogin.feature:3
    Given I visit a login form                                     # features/step_definitions/login.rb:3
    Then I will enter my username "tester@crossbrowsertesting.com" # features/step_definitions/login.rb:7
    Then I enter my password "test123"                             # features/step_definitions/login.rb:11
    Then I will click the login button                             # features/step_definitions/login.rb:15
    Then I should see "You are now logged in!"                     # features/step_definitions/login.rb:19

1 scenario (1 passed)
5 steps (5 passed)
0m14.478s
```

And there we go, our first successful test using Capybara and CBT. Start writing your own tests and see them run in the cloud!

## Local Connection

If you need to test a local site, you can use our [local connection](https://help.crossbrowsertesting.com/local-connection/general/local-tunnel-overview/) to allow our devices to access it. You can start a local connection manually using one of the methods in that link, or you can use the code below to automatically start the local connection tunnel.

In the same directory as your env.rb file, let's create a new file called tunnel.rb. Copy the following code into that file:

```
require 'rest-client'

def start_tunnel(username, authkey)
  response = RestClient.get('https://' + username + ':' + authkey + '@crossbrowsertesting.com/api/v3/tunnels?num=1')
  response = JSON.parse(response)
  tunnel_state = response['tunnels'][0]['state']

  if tunnel_state != 'running'
    puts 'Running cbt_tunnels'
    tunnel = fork do
      tunnel_user = username.sub('%40', '@')
      proc = "cbt_tunnels --username " + tunnel_user + ' --authkey ' + authkey + ' > tunnel.log'
      exec proc
    end
    Process.detach(tunnel)

    begin
      response = RestClient.get('https://' + username + ':' + authkey + '@crossbrowsertesting.com/api/v3/tunnels?num=1')
      response = JSON.parse(response)
      puts response['tunnels'][0]['state']
      tunnel_state = response['tunnels'][0]['state']
      sleep(4.0)
    end while (tunnel_state != 'running')
  end 
end
```
This code requires our Node.js module in order to run. You can install it by using the following command:

Windows: `npm install -g cbt_tunnels`

Mac/Linux: `sudo npm install -g cbt_tunnels`

If you don't have npm, you can download it here: https://nodejs.org/en/

Now if we uncomment the corresponding lines (3 and 8) in our env.rb file, we should see that our script starts a local connection if it doesn't already see one running. Now you can run tests to any resources located on your local network.

If you have any trouble getting your automated scripts setup and running on our environment, don't hesitate to [reach out to us](mailto:support@crossbrowsertesting.com). We're happy to help. 

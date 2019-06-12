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
  caps['record_network'] = 'false'   

  Capybara::Selenium::Driver.new(app,
                                 :browser => :remote,
                                 :url => url,
                                 :desired_capabilities => caps)
end

Capybara.default_driver = 'selenium_remote_cctest'.to_sym
Capybara.app_host = "http://www.yourawesomewebsite.com"
Capybara.run_server = false

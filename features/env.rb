require 'selenium/webdriver'
require 'capybara/cucumber'
require_relative 'tunnel'
username = "<yourusername>" # your username
authkey = "<yourauthkey>" # your authkey
url = "http://#{username}:#{authkey}@hub.crossbrowsertesting.com/wd/hub"

start_tunnel(username,authkey)

Capybara.register_driver 'selenium_remote_cctest'.to_sym do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.new
  capabilities['name'] = 'Selenium Test Example'
  capabilities['build'] = '1.0'
  # request the latest version of firefox. try chrome-latest for latest chrome
  capabilities['browser_api_name'] = 'ff-latest'
  capabilities['os_api_name'] = 'Mac10.12'
  capabilities['screen_resolution'] = '1366x768'
  capabilities['record_video'] = 'true'
  capabilities['record_network'] = 'true'   

  Capybara::Selenium::Driver.new(app,
                                 :browser => :remote,
                                 :url => url,
                                 :desired_capabilities => capabilities)
end

Capybara.default_driver = 'selenium_remote_cctest'.to_sym
Capybara.app_host = "http://www.yourawesomewebsite.com"
Capybara.run_server = false



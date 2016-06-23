require 'selenium/webdriver'
require 'capybara/cucumber'

username = "" # your username
authkey = "" # your authkey
url = "http://#{username}:#{authkey}@hub.crossbrowsertesting.com/wd/hub"

Capybara.register_driver 'selenium_remote_cctest'.to_sym do |app|

  capabilities = Selenium::WebDriver::Remote::Capabilities.new
	capabilities['name'] = 'Selenium Test Example'
	capabilities['build'] = '1.0'
	capabilities['browser_api_name'] = 'FF45'
	capabilities['os_api_name'] = 'Mac10.11'
	capabilities['screen_resolution'] = '1024x768'
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
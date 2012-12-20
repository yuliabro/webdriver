require "test/unit"
require "rubygems"
require "selenium-webdriver"

SELENIUM_HUB = ENV['SELENIUM_HUB']
SELENIUM_HOST = ENV['SELENIUM_HOST']
SAUCELABS_PLATFORM = ENV['SAUCELABS_PLATFORM'] || :windows_firefox3
RUNNER = ENV['RUNNER']
EXECUTOR = ENV['EXECUTOR']
SELENIUM_TEST_URL = ENV['SELENIUM_TEST_URL']
LOCAL_RUN = ENV['LOCAL_RUN']

module SeleniumTestHelper

  BROWSER_PLATFORMS = {
    :windows_firefox3 => ['Windows 2003', 'firefox', '3.6.'],
    :windows_safari => ['Windows 2003', 'safari', '4.'],
    :windows_ie8 => ['WINDOWS', 'iehta', '8.'],
    :windows_ie7 => ['Windows 2003', 'iehta', '7.'],
    :windows_ie6 => ['Windows 2003', 'iehta', '6.'],
    :windows_chrome => ["Windows 2003", "googlechrome", ""],
  }

  def setup
    platform = ENV['PLATFORM']
    @runner =ENV['RUNNER']

    if platform == 'headless'
      headless = Headless.new
      headless.start
      at_exit do
        headless.destroy
      end
    end

    if platform == 'sauce_windows_firefox'
      caps = Selenium::WebDriver::Remote::Capabilities.firefox
      caps.version = '7'
      caps.platform = :XP
      caps[:name] = self.to_s
    end

    if platform == 'windows_firefox7'
      caps = Selenium::WebDriver::Remote::Capabilities.firefox
      #caps.version = '7.0.1'
      #caps.platform = :WINDOWS
    end

    if platform == 'linux_firefox'
      caps = Selenium::WebDriver::Remote::Capabilities.firefox
      caps.platform = :LINUX
    end

    if platform == 'windows_firefox'
      caps = Selenium::WebDriver::Remote::Capabilities.firefox
      caps.version = '15.0'
      caps.platform = :WINDOWS
    end

    if platform == 'windows_ie9'
      caps = Selenium::WebDriver::Remote::Capabilities.ie
      caps.version = '9.0'
      caps.platform = :WINDOWS
    end

    if platform == 'windows_firefox3_ja'
      caps = Selenium::WebDriver::Remote::Capabilities.firefox
      caps.version = "3.6.17"
      caps.platform = :WINDOWS
    end

    if platform == 'windows_firefox3'
      caps = Selenium::WebDriver::Remote::Capabilities.firefox
      caps.version = "3.6.18"

      caps.platform = :WINDOWS
    end

    if platform == 'xp_firefox6'
      caps = Selenium::WebDriver::Remote::Capabilities.firefox
      caps.version = "6.0.2"
      caps.platform = :WINDOWS
    end

    if platform == 'xp_ie8'
      caps = Selenium::WebDriver::Remote::Capabilities.ie
      caps.version = "8"
      caps.platform = :WINDOWS
    end

    if platform == 'windows_chrome'
      caps = Selenium::WebDriver::Remote::Capabilities.chrome
      caps.platform = :WINDOWS
    end

    if platform == 'windows_opera'
      caps = Selenium::WebDriver::Remote::Capabilities.opera
      caps.version = "11"
      caps.platform = :WINDOWS
      # caps.binary = "C:\Users\yulia\Desktop\Opera\opera.exe"
    end

    if LOCAL_RUN
      url = SELENIUM_TEST_URL
      @driver = Selenium::WebDriver.for :firefox
    else

      # Remote Set up (default)

      client = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout = 120 # seconds

      if EXECUTOR=='sauce_labs'
        @driver = Selenium::WebDriver.for(
          :remote,
          :url => "http://smartfm:18b3a614-41d8-4d82-8f6d-5585eb4bbbf0@ondemand.saucelabs.com:80/wd/hub",
          :desired_capabilities => caps)
      elsif platform == 'headless'
        require 'headless'
        @driver = Selenium::WebDriver.for :firefox
      else
        webdriver_hub = '/wd/hub'
        port =':4444'
        @driver = Selenium::WebDriver.for(
          :remote,
          :url => 'http://' + SELENIUM_HUB + port + webdriver_hub,
          :desired_capabilities => caps,
          :http_client => client
        )
        @driver.manage.timeouts.implicit_wait = 10
        if platform == 'windows_firefox' || platform == 'linux_firefox' #only firefox supports resizing window
          max_width, max_height = @driver.execute_script("return [window.screen.availWidth, window.screen.availHeight];")
          @driver.manage.window.resize_to(max_width, max_height)
        end
      end
    end

    # Define various user types for testing
    @test_user = 'test@mailinator.com'
    @test_password = '123456'
 end

  def element(locator)
    @driver.find_element(locator)
  rescue Selenium::WebDriver::Error::NoSuchElementError
    nil
  end

  def teardown
    if !passed?
      take_screenshot("#{self.class}(#{self.__name__})")
    end
    if element(:css => "a[href='/account/edit']")
      @driver.execute_script("$('.global_navi .user_navi .dropdown .content ul li:nth-child(4) a').click()")
    end
    @driver.quit
  end

  def take_screenshot(test_name)
    @base_dir ='/test/selenium/screenshots/failed'
    if @runner == 'selenium_grid'
      if File.exists?(File.join(Dir.pwd + @base_dir))
        shot_dir = Dir.pwd + @base_dir
      else
        shot_dir = FileUtils.mkdir_p(File.join(Dir.pwd + @base_dir))
        shot_dir = shot_dir[0]
      end
    else
      if File.exists?(File.join(Dir.pwd + '/iknow_sel' + @base_dir))
        shot_dir = Dir.pwd + '/iknow_sel' + @base_dir
      else
        shot_dir = FileUtils.mkdir_p(File.join(Dir.pwd + '/iknow_sel' + @base_dir))
        shot_dir = shot_dir[0]
      end
    end
    @driver.save_screenshot(shot_dir + '/' + test_name + '_' + Time.now.to_s + '.png')
  end
end



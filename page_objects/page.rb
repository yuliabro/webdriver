# -*- coding: utf-8 -*-

class Page

  def initialize(driver, test_case)  # method that passes the selenium object
    @driver = driver
    @test = test_case
    setup_instance_elements(driver)
  end

  def all_elements_displayed?
      wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      @elements.all? do |name, elem|
      elem.element && elem.displayed?
    end
  end

  def print_elements_names
    names = []
    @elements.each do |name, elem|
      names << name
    end
    puts names.join(", ")
  end

  def method_missing(method, *args)
    if /^assert/ =~ method.to_s
      @test.send(method, *args)
    else
      super
    end
  end

  def self.page_elements
    @page_elements ||= common_elements
  end

  def self.common_elements
    [[:q_and_a_menu_item, :css => "a[href='/qa/topics']"], [:courses_menu_item, :css => "a[href='/content']"] ]
  end

  def self.element(name, locator)
    self.page_elements << [name, locator]

    define_method(name.to_sym) do
      @elements[name.to_sym]
    end
  end

  def setup_instance_elements(driver)
    @elements = Hash.new
    self.class.page_elements.each do |name, locator|
      @elements[name.to_sym] = Element.new(name, locator, driver)
    end
  end

  def browser_go_back(n)
    n.times do
    @driver.navigate.back
    end
  end

  def refresh_page(n)
    n.times do
      body = @driver.find_element(:xpath => "/html/body")
      body.send_keys(:f5)
    end
  end

# convenience methods available to all pages
# usage in test:
# q_and_a_page = home_page.click_questions_and_tips_menu_item(@driver, self)

  def click_courses_menu_item(driver, test)
    elem = @elements[:courses_menu_item]
    elem.click
    ContentPage.new(driver, test)
  end

end

class Element

  def initialize(name, locator, driver)  # method that passes the selenium object
    @name = name
    @locator = locator
    @driver = driver
  end

  def call(*args)  #Proc rule, see Home page, def count_statistics
    if @locator.kind_of?(Proc)
      copy = self.clone
      copy.instance_variable_set("@locator", @locator.call(*args))
      copy
    else
      self
    end
  end

  def all
    @driver.find_elements(@locator)
  end

  def element
    @driver.find_element(@locator)
  rescue Selenium::WebDriver::Error::NoSuchElementError
    puts "The following element '#{@name}' with locator '#{@locator}' was not found on the page."
    nil
  end

  def displayed?
    (e = element) && e.displayed?
  rescue Selenium::WebDriver::Error
    puts "The following element '#{@name}' with locator '#{@locator}' was not found on the page."
  end

  def selected?
    (e = element) && e.selected?
  end

  def click
    element.click
  end

  def text
    @driver.find_element(@locator).text
  end

  def value
    @driver.find_element(@locator).attribute('value')
  end

  def empty?
     element.text.empty?
  end

  def send_keys(*args)
    element.send_keys(*args)
  end

  def submit
    element.submit
  end

  def clear
    element.clear
  end

  def attribute(*args)
    element.attribute(*args)
  end

  def wait_for_element(timeout)
    wait = Selenium::WebDriver::Wait.new(:timeout => timeout)
    wait.until { @driver.find_element(@locator).displayed? }
  end

  def wait_for_element_text(timeout)
    wait = Selenium::WebDriver::Wait.new(:timeout => timeout)
    wait.until { !@driver.find_element(@locator).text.empty? }
  end

  def wait_for_element_and_click(timeout)
    wait = Selenium::WebDriver::Wait.new(:timeout => timeout)
    wait.until { @driver.find_element(@locator).displayed? }
    @driver.find_element(@locator).click
  end

  def wait_for_element_and_send_keys(timeout, keys)
    wait = Selenium::WebDriver::Wait.new(:timeout => timeout)
    wait.until { @driver.find_element(@locator).displayed? }
    @driver.find_element(@locator).send_keys(keys)
  end

  def clear_and_send_keys_to_element(*args)
    element.clear
    element.send_keys(*args)
  end

  def click_and_send_keys_to_element(*args)
    element.click
    element.send_keys(*args)
  end

  #native checked? only works with checkboxes/radio. sometimes we have input as checkbox
  def checked?
    element_state = @driver.execute_script("return $('#{@locator[:css]}').is(':checked');")
    if element_state
      true
    else
      false
    end
  end
end


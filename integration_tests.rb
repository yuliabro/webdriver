# -*- coding: utf-8 -*-
require_relative 'selenium_test_helper'
require_relative 'page_objects/google_search_page'
require_relative 'page_objects/google_result_page'

require "rubygems"
require "selenium-webdriver"

class IntegrationTests < Test::Unit::TestCase
  include SeleniumTestHelper

  def test_user_can_search_on_google
    search_page = GoogleSearchPage.new(@driver, self)
    search_page.open
    result_page = search_page.search("cheese")
    result_page.smoke_test
  end

end

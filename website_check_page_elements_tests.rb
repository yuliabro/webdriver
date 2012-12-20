# -*- coding: utf-8 -*-
require_relative 'selenium_test_helper'
require_relative 'page_objects/google_search_page'

require "uri"
require "rubygems"
require "selenium-webdriver"

class WebsiteCheckPageElements < Test::Unit::TestCase
  include SeleniumTestHelper

=begin
  Website Check Page tests should check that the all the inportant elements are present on the pages

  This test unit should be able to be run across all environments, so if you are changing this, consider what
  users and data you have available to you that is commom to all.

=end

  def test_google_search_page
    search_page = GoogleSearchPage.new(@driver, self)
    search_page.open
    search_page.check_page_elements
  end

end


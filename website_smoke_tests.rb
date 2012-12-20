# -*- coding: utf-8 -*-
require_relative 'selenium_test_helper'
require_relative 'page_objects/google_search_page'

require "uri"
require "rubygems"
require "selenium-webdriver"

class WebsiteSmokeTest < Test::Unit::TestCase
  include SeleniumTestHelper

=begin
  Smoke tests check if main pages and app welcome screens are loaded and that's about it.
  If we can do this consistently, we will catch most of the stupid errors that would otherwise go out.

  This test should be able to be run across all environments, so if you are changing this, consider what
  users and data you have available to you that is commom to all.
=end

  def test_google_search_page
    search_page = GoogleSearchPage.new(@driver, self)
    search_page.open
    search_page.smoke_test
  end
end

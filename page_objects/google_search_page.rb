# -*- coding: utf-8 -*-
require_relative 'page'
require_relative 'google_result_page'

class GoogleSearchPage < Page
  element :google_logo, :css => "div[id='lga']"
  element :search_input, :css => "input[name='q']"

  def open
    @driver.get 'http://google.com'
  end
  
  def smoke_test
    assert search_input.displayed?, "Top google page is not loaded properly."
  end

  def check_page_elements
    page_elements = [google_logo, search_input]
    assert page_elements.reject(&:displayed?).empty?, "Some elements on top google page are not displayed."
  end

  def search(term)
    search_input.send_keys(term)
    search_input.send_keys(:return)
    GoogleResultPage.new(@driver, self)
  end
end

# -*- coding: utf-8 -*-
require_relative 'page'
require_relative 'google_search_page'

class GoogleResultPage < Page
  element :page_title, :css => "title"
  element :search_result_header, :css => "h3[class='r']" 

  def smoke_test
    assert search_result_header.displayed?, "Google search result page is not loaded properly."
  end

  def check_page_elements
    page_elements = [page_title, search_result_header]
    assert page_elements.reject(&:displayed?).empty?, "Some elements on google search result page are not displayed."
  end
end

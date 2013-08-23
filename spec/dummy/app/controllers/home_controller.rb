# encoding: utf-8
class HomeController < ApplicationController
  def index
    @company = Company.new
    @company.region_code = 331002
  end
end

# encoding: utf-8
class HomeController < ApplicationController
  def index
    @company = Company.new
    @company.region_code = 331002
  end

  def valid
    @company = Company.new(params[:company])
    @company.valid?
    render :index
  end

  def rails4
    @company = Company.new
    @company.region_code = 331002
  end
end

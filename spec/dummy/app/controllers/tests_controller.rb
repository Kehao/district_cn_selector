# encoding: utf-8
class TestsController < ApplicationController
  def show
    @company = Company.new
    @company.region_code = 341002
    @company.loc_code = 341002

    render params[:id]
  end
end

# encoding: utf-8
require 'spec_helper'

describe "SimpleForm" do
  #include ViewTestHelper
  include SimpleForm::ActionViewExtensions::FormHelper
  let(:company) { Company.new(:loc_code=>331002)}
  let(:unvalid_company) { Company.new }

  context "select_ul" do
    it 'renders province select-ul' do
      concat(simple_form_for(company,:url=>"") do |f|
        f.input :loc_code, :as => :province_select_ul
      end)
      assert_select 'div.province_select_ul'
      assert_select 'div.province'

      assert_select 'input.select-value'
    end

    it 'renders city select-ul' do
      concat(simple_form_for(company,:url=>"") do |f|
        f.input :loc_code, :as => :city_select_ul
      end)
      assert_select 'div.city_select_ul'
      assert_select 'div.province'
      assert_select 'div.city'

      assert_select 'input.select-value'
    end 

    it 'renders district select-ul' do
      concat(simple_form_for(company,:url=>"") do |f|
        f.input :loc_code, :as => :district_select_ul
      end)
      assert_select 'div.district_select_ul'
      assert_select 'div.province'
      assert_select 'div.city'
      assert_select 'div.district'

      assert_select 'input.select-value'
    end
    it 'validates :loc_code, presence: true' do
      expect(unvalid_company.valid?).to be_false

      concat(simple_form_for(unvalid_company,:url=>"") do |f|
        f.input :loc_code, :as => :district_select_ul
      end)

      assert_select 'div.district_select_ul'
      assert_select '.error'
    end
  end

  context "select" do
    it 'renders province select' do
      concat(simple_form_for(company,:url=>"") do |f|
        f.input :loc_code, :as => :province_select
      end)
      assert_select 'div.province_select'
      assert_select 'select.province'

      assert_select 'input.select-value'
    end

    it 'renders city select' do
      concat(simple_form_for(company,:url=>"") do |f|
        f.input :loc_code, :as => :city_select
      end)
      assert_select 'div.city_select'
      assert_select 'select.province'
      assert_select 'select.city'

      assert_select 'input.select-value'
    end

    it 'renders district select' do
      concat(simple_form_for(company,:url=>"") do |f|
        f.input :loc_code, :as => :district_select
      end)
      assert_select 'div.district_select'
      assert_select 'select.province'
      assert_select 'select.city'
      assert_select 'select.district'

      assert_select 'input.select-value'
    end

    it 'validates :loc_code, presence: true' do
      expect(unvalid_company.valid?).to be_false

      concat(simple_form_for(unvalid_company,:url=>"") do |f|
        f.input :loc_code, :as => :district_select
      end)

      assert_select '.error'
    end

  end

end

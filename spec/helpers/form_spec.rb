# encoding: utf-8
require 'spec_helper'
describe "Form" do
  #include ViewTestHelper
  let(:company) { Company.new(:loc_code=>331002)}
  let(:unvalid_company) { Company.new }

  before { 
    @builder = DistrictCnSelector::Helpers::FormBuilder
  }

  context "select_ul" do
    it 'renders province select-ul' do
      concat(form_for(company,:url=>"",:builder=>@builder) do |f|
        f.province_select_ul :loc_code
      end)
      assert_select 'div.district_cn_selector'
      assert_select 'div.province'

      assert_select 'input.select-value'
    end

    it 'renders city select-ul' do
      concat(form_for(company,:url=>"",:builder=>@builder) do |f|
        f.city_select_ul :loc_code
      end)
      assert_select 'div.district_cn_selector'
      assert_select 'div.province'
      assert_select 'div.city'

      assert_select 'input.select-value'
    end 

    it 'renders district select-ul' do
      concat(form_for(company,:url=>"",:builder=>@builder) do |f|
        f.district_select_ul :loc_code
      end)

      assert_select 'div.district_cn_selector'
      assert_select 'div.province'
      assert_select 'div.city'
      assert_select 'div.district'

      assert_select 'input.select-value'
    end
    it 'validates :loc_code, presence: true' do
      expect(unvalid_company.valid?).to be_false

      concat(form_for(unvalid_company,:url=>"",:builder=>@builder) do |f|
        f.district_select_ul :loc_code
      end)

      assert_select '.field_with_errors',2
    end
  end

  context "select" do
    it 'renders province select' do
      concat(form_for(company,:url=>"",:builder=>@builder) do |f|
        f.province_select :loc_code
      end)

      assert_select 'div.district_cn_selector'
      assert_select 'select.province'

      assert_select 'input.select-value'
    end

    it 'renders city select' do
      concat(form_for(company,:url=>"",:builder=>@builder) do |f|
        f.city_select :loc_code
      end)

      assert_select 'div.district_cn_selector'
      assert_select 'select.province'
      assert_select 'select.city'

      assert_select 'input.select-value'
    end

    it 'renders district select' do
      concat(form_for(company,:url=>"",:builder=>@builder) do |f|
        f.district_select :loc_code
      end)
      assert_select 'div.district_cn_selector'
      assert_select 'select.province'
      assert_select 'select.city'
      assert_select 'select.district'

      assert_select 'input.select-value'
    end

    it 'validates :loc_code, presence: true' do
      expect(unvalid_company.valid?).to be_false

      concat(form_for(unvalid_company,:url=>"",:builder=>@builder) do |f|
        f.district_select :loc_code
      end)

      assert_select '.field_with_errors',2
    end

  end

end


# encoding: utf-8
require 'action_view/helpers/url_helper'

module ActionView
  module Helpers
    module FormOptionsHelper
      def district_select_ul(object, method, region_code=nil, options={}, html_options={})
        tag = InstanceTag.new(object, method, self, options.delete(:object))
        tag.to_district_select_ul_tag(region_code, options, html_options)
      end

      alias_method :area_select_ul, :district_select_ul

      def city_select_ul(object, method, region_code=nil, options={}, html_options={})
        tag = InstanceTag.new(object, method, self, options.delete(:object))
        tag.to_city_select_ul_tag(region_code, options, html_options)
      end

      def province_select_ul(object, method, region_code=nil, options={}, html_options={})
        tag = InstanceTag.new(object, method, self, options.delete(:object))
        tag.to_province_select_ul_tag(region_code, options, html_options)
      end
    end

    module SelectUlHelperInstanceTag
      def to_district_select_ul_tag(region_code=nil,options={}, html_options={})
        district_ul_selector(region_code, options, html_options).to_select(:district)
      end

      def to_city_select_ul_tag(region_code=nil,options={}, html_options={})
        district_ul_selector(region_code, options, html_options).to_select(:city)
      end

      def to_province_select_ul_tag(region_code=nil,options={}, html_options={})
        district_ul_selector(region_code, options, html_options).to_select(:province)
      end

      private
      def district_ul_selector(region_code,options, html_options)
        DistrictCnSelector::SelectUlSelector.new(self, region_code, options, html_options)
      end
    end

    class InstanceTag #:nodoc:
      include SelectUlHelperInstanceTag
    end

  end
end


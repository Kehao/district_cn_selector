module ActionView
  module Helpers
    #module DistrictSelectUlHelper
    module FormOptionsHelper
      def district_select_ul(object_name, method, options={}, html_options={})
        Tags::DistrictSelectUl.new(object_name, method, self, options, html_options).render
      end

      #def select_ul_district(region_code=nil,options= {},html_options = {})
      #  DistrictSelectUlSelector.new(region_code, options, html_options).select_date
      #end

    end

    module Tags
      class DistrictSelectUl < Base
        def initialize(object_name, method_name, template_object, options, html_options)
          @html_options = html_options
          super(object_name, method_name, template_object, options)
        end

        def render
          error_wrapping(district_select_ul_selector(@options, @html_options).send("to_select",:district).html_safe)
        end
        private

        def district_select_ul_selector(options, html_options)
          DistrictCnSelector::SelectUlSelector.new(value(object), options, html_options)
        end

      end

    end
  end
end

# encoding: utf-8
module DistrictCnSelector
  module Helpers
    module FormBuilderExtension
      #select
      def district_select(method, options={}, html_options={})
        region_code = self.object.public_send(method)
        @template.district_select(@object_name, method,
                                 region_code, objectify_options(options), html_options)
      end
      alias_method :area_select, :district_select

      def city_select(method, options={}, html_options={})
        region_code = self.object.public_send(method)
        @template.city_select(@object_name, method,
                                 region_code, objectify_options(options), html_options)
      end

      def province_select(method, options={}, html_options={})
        region_code = self.object.public_send(method)
        @template.province_select(@object_name, method,
                                     region_code, objectify_options(options), html_options)
      end


      #select-ul
      def district_select_ul(method, options={}, html_options={})
        region_code = self.object.public_send(method)
        @template.area_select_ul(@object_name, method,
                                 region_code, objectify_options(options), html_options)
      end
      alias_method :area_select_ul, :district_select_ul

      def city_select_ul(method, options={}, html_options={})
        region_code = self.object.public_send(method)
        @template.city_select_ul(@object_name, method,
                                 region_code, objectify_options(options), html_options)
      end

      def province_select_ul(method, options={}, html_options={})
        region_code = self.object.public_send(method)
        @template.province_select_ul(@object_name, method,
                                     region_code, objectify_options(options), html_options)
      end

      
    end
  end
end

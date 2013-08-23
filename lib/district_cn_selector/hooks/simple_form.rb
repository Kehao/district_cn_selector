#require 'active_support/concern'
module DistrictCnSelector
  module Hooks
    module SimpleFormBuilderExtension
      class SelectBase < SimpleForm::Inputs::Base
        def scope_input(scope)
          opts = options.extract!(:theme, :prompt_class)
          if SimpleForm.default_wrapper.eql?(:bootstrap) && opts[:theme].nil?
            opts.merge!(:theme => :bootstrap)
          end
          @builder.public_send(scope, attribute_name, opts.merge(:simple_form => true))
        end
      end
      #select
      class DistrictSelectInput < SelectBase 
        def input
          scope_input(:district_select)
        end
      end

      class AreaSelectInput < DistrictSelectInput

      end

      class CitySelectInput < SelectBase 
        def input
          scope_input(:city_select)
        end
      end

      class ProvinceSelectInput < SelectBase 
        def input
          scope_input(:province_select)
        end
      end
      
      #select-ul
      class DistrictSelectUlInput < SelectBase 
        def input
          scope_input(:area_select_ul)
        end
      end

      class AreaSelectUlInput < DistrictSelectUlInput

      end

      class CitySelectUlInput < SelectBase
        def input
          scope_input(:city_select_ul)
        end
      end

      class ProvinceSelectUlInput < SelectBase
        def input
          scope_input(:province_select_ul)
        end
      end


    end
  end
end

::SimpleForm::FormBuilder.send :include, 
                               DistrictCnSelector::Helpers::FormBuilderExtension
::SimpleForm::FormBuilder.send :include,
                               DistrictCnSelector::Hooks::SimpleFormBuilderExtension





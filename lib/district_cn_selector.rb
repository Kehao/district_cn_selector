require "district_cn"
require "district_cn_selector/engine"

module DistrictCnSelector
  autoload :Theme, 'district_cn_selector/theme'
  autoload :DistrictController, 'district_cn_selector/district_controller'

  module Helpers
    autoload :FormBuilderExtension, 'district_cn_selector/helpers/form_builder_extension'
    autoload :FormBuilder, 'district_cn_selector/helpers/form_builder'
  end

  begin
    require 'simple_form'
    require 'district_cn_selector/hooks/simple_form'
  rescue LoadError
  end

  require 'district_cn_selector/selector'
  require 'district_cn_selector/district_select_ul_helper'
  require 'district_cn_selector/district_select_helper'
end

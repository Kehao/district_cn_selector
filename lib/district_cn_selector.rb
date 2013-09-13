require "district_cn"
require "district_cn_selector/engine"

module DistrictCnSelector
  autoload :Theme, 'district_cn_selector/theme'
  autoload :DistrictController, 'district_cn_selector/district_controller'

  module Helpers
    autoload :FormBuilderExtension, 'district_cn_selector/helpers/form_builder_extension'
    autoload :FormBuilder, 'district_cn_selector/helpers/form_builder'
  end

  def self.rails4?
    Rails::VERSION::MAJOR == 4
  end


  begin
    require 'simple_form'
    require 'district_cn_selector/hooks/simple_form'
  rescue LoadError
  end

  if self.rails4?
    require 'district_cn_selector/rails4/selector'
    require 'district_cn_selector/rails4/district_select_ul_helper'
  else
    require 'district_cn_selector/selector'
    require 'district_cn_selector/district_select_ul_helper'
    require 'district_cn_selector/district_select_helper'
  end

end

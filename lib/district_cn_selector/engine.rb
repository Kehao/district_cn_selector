module DistrictCnSelector
  class Engine < ::Rails::Engine

  end
end
#    initializer "area_select_cn.active_model_ext" do
#      ActiveSupport.on_load :active_record do
#        ActiveRecord::Base.send :include, AreaSelectCn::ActsAsAreaSelectable
#      end
#    end
#config.generators do |g|
#  g.test_framework      :rspec,        :fixture => false
#  g.fixture_replacement :factory_girl, :dir => 'spec/factories'
#  g.assets false
#  g.helper false
#end

#initializer "area_select_cn.view_helpers" do
#  ::ActiveSupport.on_load(:action_view) do
#    ::ActionView::Base.send :include, AreaSelectCn::Helper
#  end
#end


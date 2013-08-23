Rails.application.routes.draw do
  # 返回树状结构的省，市，区县数据
  get '/district_cn_selector/district',
    :to => DistrictCnSelector::DistrictController.action(:index)
  get '/district_cn_selector/district/search',
    :to => DistrictCnSelector::DistrictController.action(:search)
end

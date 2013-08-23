# encoding: utf-8
module DistrictCnSelector
  class DistrictController < ActionController::Base
    layout nil
    # 返回树状结构的整个省份，城市，区域列表，
    # 避免选择地区时的多次请求 
    def index
      code = params[:region_code] 
      results = 
        if code 
          DistrictCn.code(code).children
        else
          DistrictCn.tree
        end
      render :json => results
    end

    def search
      ids = []
      if params[:region_name]
        ids = DistrictCn.search(params[:region_name])
      end
      render :json => ids.map{|id|{:id=>id.code,:text=>id.area_name}}
    end
  end
end

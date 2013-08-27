# encoding: utf-8
require 'spec_helper'

describe DistrictCnSelector::DistrictController do

    it "should return json list" do
      expected={"330000" => { :text=>"浙江省",:children=>{ "330100"=> { :text=>"杭州市", :children=>{ "330108"=>{:text=>"滨江区"} }}}}}
      DistrictCn.stub(:tree).and_return(expected)
      get :index, {}
      expect(response.body).to eq(expected.to_json)
    end

end

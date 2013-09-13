class Company < ActiveRecord::Base
  attr_accessor :region_code
  unless DistrictCnSelector.rails4?
    attr_accessible :region_code, :loc_code
  end

  act_as_area_field :region_code
  validates :region_code, presence: true
  validates :loc_code, presence: true
end

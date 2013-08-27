module DistrictCnSelector
  module Theme 
    def self.district_select_ul
      {
        :default => {
        :select         => {:class=>"select-input"},
        :select_options => {:class=>"select-opts"},
        :select_prompt  => {:class=>"select-prompt"},
        :caret          => {:class=>"select-tangle"} },

        :bootstrap => {
        :select         => {:class=>"btn-group"},
        :select_options => {:class=>"dropdown-menu"},
        :select_prompt  => {:class=>"dropdown-toggle"},
        :caret          => {:class=>"caret"}}
      }
    end
  end
end

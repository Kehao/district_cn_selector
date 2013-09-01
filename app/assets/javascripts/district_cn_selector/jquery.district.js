(function($){
  var jQuery = $;

  var District = function(selector, options){
    options = options || {};
    jQuery.extend(this.options, options);

    this.districtContainer = $(selector);
    this.districts = this.districtContainer.find("select");
    this.provinceSelect = $(this.districts[0]);
    this.citySelect = $(this.districts[1]);
    this.countySelect = $(this.districts[2]);

    this.resetSelectedValues();
    
    this.attachEvents();
  };

  // for `new jQuery.District()` or `jQuery.District()` 
  jQuery.District = function(selector, options){
    return new District(selector, options);
  };

  jQuery.extend(District.prototype, {
    attachEvents: function(){
      var self = this;
      this.districts.on("change", function(){
        var $this = $(this); 
        var val = $this.val();
        if(val == ''){
          self.clearAfterSelects($this);
          self.afterChange($this);
        } else {
          self.requestDistricts(val, function(data){
            self.changeAfterSelect($this, data);
            self.clearAfter2Select($this);
            self.afterChange($this);
          });
        }

      });
    },
    afterChange: function(select){
      var self = this;
      this.resetSelectedValues();
      if(jQuery.type(this.options.onChange) === 'function')
        this.options.onChange.call(select,self.districtContainer,this.curDistrict);
    },

    changeAfterSelect: function(select, data){
      $nextSelect = select.next('select');
      this.clearSelects($nextSelect);
      this.addSelectOptions($nextSelect, data);
    },

    clearAfterSelects: function(select){
      this.clearSelects(select.nextAll('select'));
    },

    clearAfter2Select: function(select){
      after2select = select.nextAll('select')[1];
      if(after2select)
        this.clearSelects($(after2select));
    },

    clearSelects: function(selects){
      selects.each(function(i, select){
        $(select).children().slice(1).remove(); 
      });
    },

    resetSelectedValues: function(){
      this.selectedProvince = this.provinceSelect.val();
      this.selectedCity = this.citySelect.val();
      this.selectedCounty = this.countySelect.val();
      this.curDistrict = this.selectedCounty || this.selectedCity || this.selectedProvince;
    },
    
    requestDistricts: function(code, callback){
      if(this.dataCache[code])
        return callback.call(this, this.dataCache[code]);
      var self = this;
      var xhr = $.get(this.options.url + code, function(data){
        self.dataCache[code] = $.type(data) === 'string' ? $.parseJSON(data) : data;
        callback.call(self, self.dataCache[code]);
      }, 'json');
    },

    addSelectOptions: function(select, districts){
      var optionEles = []
      $.each(districts, function(i, district){
        optionEles.push($(document.createElement("option")).attr({value: district[1]}).text(district[0]));
      });
      $.each(optionEles, function(i, ele){
        select.append(ele);
      });
    },

    options: {
      url: '/district_cn_selector/district?region_code=',
      onChange: null 
    },
    dataCache: {},
    selectedProvince: null,
    selectedCity: null,
    selectedCounty: null,
    curDistrict: null
  });
})($);

$(document).ready(function () {
    if (window.AREA_SELECT_CN_DISTRICT_FIELDS !== undefined) {
        for (var i in window.AREA_SELECT_CN_DISTRICT_FIELDS) {
            var f = window.AREA_SELECT_CN_DISTRICT_FIELDS[i];
            jQuery.District(f[0], f[1]);
        }
    }
});


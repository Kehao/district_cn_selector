/* 
 * jQuery DistrictUl Plugin 
 */
(function ($) {
    var jQuery = $;

    var DistrictUl = function (selector, options) {
        options = options || {};
        jQuery.extend(this.options, options);

        if (!this.options.perAjax) {
            this.loadDistrictData();  // 预先加载好区域数据
        }

        this.districtContainer = $(selector);
        this.selects = this.districtContainer.find(this.options.selectContainer);
        this.selectPrompts = this.selects.find(this.options.selectPromptContainer);
        this.selectOpts = this.selects.find(this.options.selectOptsContainer);

        this.resetSelectedValues();

        this.attachEvents();

        this.attachBody();
    };

    // for `new jQuery.DistrictUl()` or `jQuery.DistrictUl()`
    jQuery.DistrictUl = function (selector, options) {
        return new DistrictUl(selector, options);
    };

    jQuery.extend(DistrictUl.prototype, {
        loadDistrictData: function () {
            var self = this;
            if (!this.district) {
                if (!DistrictUl.data) {
                    $.get(this.options.url, function (data) {
                        DistrictUl.data = data;
                        self.district = DistrictUl.data;
                    }, self.options.dataType);
                } else {
                    self.district = DistrictUl.data;
                }
            }
        },
        attachEvents: function () {
            var self = this;
            this.selectPrompts.on('click', function () {
                var $this = $(this);
                var index = jQuery.inArray(this, self.selectPrompts);
                var $selectOpt = $(self.selectOpts[index])
                var indexes = [0, 1, 2]
                $.each(indexes, function (key, value) {
                    if (key != index) {
                        $(self.selectOpts[key]).hide();
                    }
                })
                $selectOpt.toggle();
            });
            this.selectOpts.on('click', 'li', function () {
                var $this = $(this);
                if (!$this.hasClass(self.options.selectedClass)) {
                    self.activeOpt($this);
                    var $selectOpt = $this.parent();
                    var index = jQuery.inArray($selectOpt[0], self.selectOpts);
                    self.changePrompt(index, $this);
                    var val = $this.attr(self.options.dataName);
                    if (val === '') {
                        self.clearNextSelects(index);
                        self.afterChange($this);
                    } else {
                        self.requestDistricts(val, function (data) {
                            self.changeNextSelect(index, data);
                            self.clearNext2Select(index);
                            self.afterChange($this);
                        });
                    }
                }
                $this.parent().toggle();
            });
        },
        attachBody: function () {
            var self = this;
            $('body').on('click', function (e) {
                var target = e.target;
                if (!jQuery.contains(self.districtContainer[0], target))
                    self.selectOpts.hide();
            });
        },
        afterChange: function ($opt) {
            var self = this;
            this.resetSelectedValues();
            if (jQuery.type(this.options.onChange) === 'function')
                this.options.onChange.call($opt, self.districtContainer, this.curDistrict);
        },
        resetSelectedValues: function () {
            var self = this;
            var selectedDatas = this.selectPrompts.map(function (i, p) {
                return $(p).find(":first-child").attr(self.options.dataName);
            });
            this.selectedProvince = selectedDatas[0];
            this.selectedCity = selectedDatas[1];
            this.selectedCounty = selectedDatas[2];
            this.curDistrict = this.selectedCounty || this.selectedCity || this.selectedProvince;
        },

        requestDistricts: function (code, callback) {
            if (this.dataCache[code])
                return callback.call(this, this.dataCache[code]);

            var self = this;
            if (this.options.perAjax) {
                $.get(this.options.url + code, function (data) {
                    self.dataCache[code] = $.type(data) === 'string' ? $.parseJSON(data) : data;
                    callback.call(self, self.dataCache[code]);
                }, this.options.dataType);
            } else {
                // 如果区域json数据没有, 请求区域json数据
                if (!this.district) {
                    $.get(this.options.url, function (data) {
                        self.district = data;
                        self.dataCache[code] = self.listDistrict(code);
                        callback.call(self, self.dataCache[code]);
                    }, self.options.dataType);
                } else {
                    self.dataCache[code] = self.listDistrict(code);
                    callback.call(self, self.dataCache[code]);
                }
            }
        },
        listDistrict: function (code) {
            var result = [];
            if (code.length == 0) return result;

            var id_match = code.match(/(\d{2})(\d{2})(\d{2})/);
            var province_id = id_match[1].concat("0000");
            var city_id = (id_match[1] + id_match[2]).concat("00");

            var children;
            if (this.district[province_id]) {
                children = this.district[province_id]['children'];
            }
            if (children[city_id]) {
                children = children[city_id]['children'];
            }

            for (var id in children) {
                result.push([children[id]['text'], id]);
            }

            return result.sort(function (d1, d2) {
                return d1[1] - d2[1];
            });
        },
        addSelectOptions: function ($select, data) {
            var self = this;
            var optionEles = [];
            $.each(data, function (i, district) {
                $link = $("<a href=\"javascript:void(0);\">" + district[0] + "</a>");
                $li = $(document.createElement("li"))
                    .attr(self.options.dataName, district[1])
                    .append($link)

                optionEles.push($li)
            });
            $.each(optionEles, function (i, ele) {
                $select.append(ele);
            });
        },
        changeNextSelect: function (index, data) {
            var $nextSelect = $(this.selectOpts[index + 1]);
            this.clearSelects($nextSelect);
            this.addSelectOptions($nextSelect, data);
        },
        clearNext2Select: function (index) {
            this.clearSelects(this.selectOpts.slice(index + 2));
        },
        clearNextSelects: function (index) {
            this.clearSelects(this.selectOpts.slice(index + 1));
        },
        clearSelects: function ($selectOpts) {
            var self = this;
            $selectOpts.each(function (i, selectOpt) {
                var index = jQuery.inArray(selectOpt, self.selectOpts)
                $(selectOpt).children('li').slice(1).remove();
                $(self.selectPrompts[index]).find(":first-child")
                    .text(self.options.prompts[index])
                    .attr(self.options.dataName, '');
            });
        },
        activeOpt: function ($opt) {
            $opt.toggleClass(this.options.selectedClass);
            $opt.siblings('li.' + this.options.selectedClass).toggleClass(this.options.selectedClass);
        },
        changePrompt: function (index, $opt) {
            $prompt = $(this.selectPrompts[index]);
            $prompt.find(':first-child').text($opt.text())
                .attr(this.options.dataName, $opt.attr(this.options.dataName));
        },
        dataCache: {},
        district: null,
        options: {
            selectContainer: '.select-input',
            selectOptsContainer: '.select-opts',
            selectPromptContainer: '.select-prompt',
            selectedClass: 'active',
            dataName: 'data-value',
            perAjax: false, //是每次选择区域进行请求，还是一次获得所有区域数据
            url: '/district_cn_selector/district',
            dataType: 'json',
            onChange: null,
            prompts: ['省 份', '城 市', '区 县']
        }
    });
})(jQuery);

$(document).ready(function () {
    if (window.AREA_SELECT_CN_DISTRICT_UL_FIELDS !== undefined) {
        for (var i in window.AREA_SELECT_CN_DISTRICT_UL_FIELDS) {
            var f = window.AREA_SELECT_CN_DISTRICT_UL_FIELDS[i];
            jQuery.DistrictUl(f[0], f[1]);
        }
    }
});

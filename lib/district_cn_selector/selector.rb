# encoding: utf-8
require 'action_view/helpers/tag_helper'
require 'action_view/helpers/url_helper'

module DistrictCnSelector

    class Selector
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
      attr_reader :instance_tag,:region_code,:options,:html_options

      def initialize(instance_tag, region_code, options = {}, html_options = {})
        @instance_tag = instance_tag
        @region_code = region_code
        @options = options.dup.merge(objectify_code.as_options)
        @html_options = html_options.dup
      end

      def objectify_code
        @objectify_code ||=
        region_code.is_a?(DistrictCn::Code) && region_code || DistrictCn::Code.new(region_code)
      end

      def secure_random
        @secure_random ||= "area-select-#{SecureRandom.hex}"
      end

      def control_group(type)
        controls = instance_tag.content_tag(:div, build_select(type), :class => "controls")
        label = instance_tag.to_label_tag(nil, :class => "control-label")
        content_tag(:div, [label, controls].join.html_safe, :class => "control-group area_select_cn")
      end

      def build_hidden 
        instance_tag.to_input_field_tag("hidden", :class => "select-value", :value => objectify_code.value)
      end

      def to_select(type)
        options[:simple_form] ?  build_select(type) : control_group(type)
      end

      def build_select(type)
        #rewrite
      end

      def build_one(type)
        #rewrite
      end

      def select_district
        [:province, :city, :district].map do |type|
          build_one(type)
        end.join
      end

      def select_city
        [:province, :city].map do |type|
          build_one(type)
        end.join
      end

      def select_province
        build_one(:province)
      end
      
      def selected(cur, required, class_name="active")
        required = [required].flatten
        required.index(cur) && class_name
      end
    end

    class SelectUlSelector < Selector
      BLANK = {:province => "省 份", :city => "城 市", :district => "区 县"} 

      def options
        super.merge(theme_options(super))
      end

      def theme_options(opts)
        theme = DistrictCnSelector::Theme.area_select_ul
        theme_options = theme[opts[:theme]]
        theme_options ||= theme[:default]

        if opts[:theme].eql?(:bootstrap) && opts[:prompt_class].nil?
          theme_options[:prompt_class] = "btn"
        else
          theme_options[:prompt_class] = opts[:prompt_class]
        end
        theme_options
      end

      def build_select(type)
        content_tag(
          :div, 
          [build_hidden, public_send("select_#{type}"), javascript_tag].join.html_safe, 
          :class => "#{secure_random}"
        )
      end

      def javascript_tag
        javascript = <<-JAVASCRIPT
          <script>
            if(window.AREA_SELECT_CN_DISTRICT_UL_FIELDS === undefined) {
              window.AREA_SELECT_CN_DISTRICT_UL_FIELDS = [];
            }
            window.AREA_SELECT_CN_DISTRICT_UL_FIELDS.push(
              [".#{secure_random}",
                {
                  selectContainer:        '.#{options[:select][:class]}',
                  selectOptsContainer:    '.#{options[:select_options][:class]}',
                  selectPromptContainer:  '.#{options[:select_prompt][:class]}',
                  onChange: function($container,code){
                    $container.find(".select-value").val(code);
                  }
                }
              ]
            );
          </script>
        JAVASCRIPT
        javascript
      end

      def build_one(type)
        selected_scope = options["selected_#{type}".intern]
        selected_scopes = options["selected_#{type.to_s.pluralize}".intern]

        pmt = ''
        data_value = selected_scope && {:value => selected_scope[1]} || {}
        data_text = selected_scope && selected_scope[0] || BLANK[type]
        pmt << content_tag(:span, data_text, :class => "select-content", :data => data_value)
        pmt << content_tag(:span, "", options[:caret])

        opts = ''
        blank_link = link_to(BLANK[type], "javascript:void(0);")
        opts << content_tag(:li, blank_link, :class => selected(selected_scope, nil), :data => {:value => ""})

        selected_scopes.each do |type|
          scope_link = link_to type[0], "javascript:void(0);"
          opts << content_tag(:li, scope_link, :class => selected(type[1], selected_scope && selected_scope[1]), :data => {:value => type[1]})
        end

        prompt_class = {
            :class => [options[:select_prompt][:class], options[:prompt_class]].join(" ")
        }
        prompt = link_to(pmt.html_safe, "javascript:void(0);", options[:select_prompt].merge(prompt_class))
        select_options = content_tag(:ul, opts.html_safe, options[:select_options].merge(:style => "max-height:350px;overflow:scroll"))

        select = prompt + select_options
        select_class = options[:select][:class]
        content_tag(:div, select, options[:select].merge(:class => [select_class, type].join(" ")))
      end

    end

    class SelectSelector < Selector
      BLANK = {
        :province => ["省 份",""], 
        :city => ["城 市",""], 
        :district => ["区 县",""]
      }

      def javascript_tag
        javascript = <<-JAVASCRIPT
          <script>
            if(window.AREA_SELECT_CN_DISTRICT_FIELDS === undefined) {
              window.AREA_SELECT_CN_DISTRICT_FIELDS = [];
            }
            window.AREA_SELECT_CN_DISTRICT_FIELDS.push(
              [".#{secure_random}",
                {
                  onChange: function($container,code){
                    $container.find(".select-value").val(code);
                  }
                }
              ]
            );
          </script>
        JAVASCRIPT
        javascript
      end

      def build_select(type)
        content_tag(
          :div, 
          [public_send("select_#{type}"), build_hidden, javascript_tag].join.html_safe, 
          :class => "#{secure_random}"
        )
      end

      def build_one(type)
        selected_scope =  options["selected_#{type}".intern]
        selected_scopes = options["selected_#{type.to_s.pluralize}".intern]

        instance_tag.to_select_tag(
          selected_scopes.unshift(BLANK[type]),
          {:selected =>selected_scope && selected_scope[1]}.merge(options),
          {:id=>nil,:class=>type}.merge(html_options)
        )
      end

    end
end

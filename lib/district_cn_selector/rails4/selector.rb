# encoding: utf-8
require 'action_view/helpers/tag_helper'
require 'action_view/helpers/url_helper'
module DistrictCnSelector
  class Selector
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper

    def initialize(region_code, options = {}, html_options = {})
      @options      = options.dup
      @html_options = html_options.dup
      @region_code  = region_code 
    end

    def objectify_code
      @objectify_code ||=
        region_code.is_a?(DistrictCn::Code) && region_code || DistrictCn::Code.new(region_code)
    end

    def secure_random
      @secure_random ||= "selector_#{SecureRandom.hex}"
    end

    def build_one(type)
      #overwrite
    end

    def select_district
      [:province, :city, :district].map{|type| build_one(type)}.join 
    end

    def select_city
      [:province, :city].map{|type| build_one(type)}.join
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
      theme = DistrictCnSelector::Theme.district_select_ul
      theme_options = theme[opts[:theme]]
      theme_options ||= theme[:default]

      if opts[:theme].eql?(:bootstrap) && opts[:prompt_class].nil?
        theme_options[:prompt_class] = "btn"
      else
        theme_options[:prompt_class] = opts[:prompt_class]
      end
      theme_options
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

  end
end


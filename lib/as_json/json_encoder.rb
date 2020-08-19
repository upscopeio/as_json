# frozen_string_literal: true

module AsJson
  class JsonEncoder
    def initialize(object, options)
      @object = object
      @options = as_json_options(options)
      @subobject_attributes = {}
    end

    def json
      json = attributes_to_encode.map do |attribute, method|
        if attribute == method && @object.respond_to?(method)
          [clean_json_key(attribute.to_s), @object.send(method).as_json(subobjects_as_json_options(attribute))]
        else
          value = method.is_a?(Proc) ? @object.instance_exec(&method) : @object.send(method)
          [clean_json_key(attribute.to_s), value.as_json(subobjects_as_json_options)]
        end
      end.to_h

      json['id'] = @object.hashed_id if @object.respond_to?(:hashed_id) && json['id'].blank?
      json = json.sort_by { |k, _v| k == 'id' ? '_id' : k }.to_h
      json['_type'] = @object.class.name.underscore
      json.except(*[@options[:without] || []].flatten.map(&:to_s))
    end

    private

    def subobjects_as_json_options(object = nil)
      options = {}
      options.merge!({ _default_attributes: @subobject_attributes[object.to_sym] }) if object && @subobject_attributes[object.to_sym]
      options.merge!(@options.except(:_default_attributes, :only, :without, :with))
    end

    def clean_json_key(key)
      key = key[0..-2] if key.end_with?('?')
      key
    end

    def as_json_options(opts)
      opts[:_default_attributes] ||= @object.class.default_json_attributes
      return opts if opts[:with_only].blank?

      opts[:with] = opts[:with_only]
      opts[:only] = opts[:with_only]
      opts
    end

    def attributes_to_encode
      attrs = [@options[:with] || []].flatten.map { |attr| [attr, attr] }
      add_defaults_to_attributes(attrs, @options[:_default_attributes]) if @options[:_default_attributes].present?

      attrs = attrs.select { |attr, _| attr.in? [@options[:only]].flatten } if @options[:only].present?
      attrs = attrs.reject { |attr, _| attr.in? [@options[:without]].flatten } if @options[:without].present?
      attrs
    end

    def add_defaults_to_attributes(attrs, default_attributes)
      default_attributes.each do |scope, scoped_attributes|
        if scope == :_base
          # These are just default attributes
          attrs.push(*scoped_attributes.map { |a| [a, a] })
        elsif (scoped_attributes.is_a?(Array) || scoped_attributes.is_a?(Hash)) && !scope.to_s.start_with?('with_')
          # These are associations with sub configuration
          attrs.push([scope, scope])
          @subobject_attributes[scope] = if scoped_attributes.is_a?(Hash)
                                           scoped_attributes
                                         else
                                           { _base: scoped_attributes }
                                         end
        elsif !scope.to_s.start_with?('with_')
          # These are aliases for a different method
          attrs.push([scope, scoped_attributes == true ? scope : scoped_attributes])
        elsif @options[scope] || @options[:with_everything] == true
          # This is if the options include with_xyz
          scoped_attributes = { _base: [scoped_attributes].flatten } unless scoped_attributes.is_a?(Hash)
          add_defaults_to_attributes attrs, scoped_attributes
        end
      end
    end
  end
end

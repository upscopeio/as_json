# frozen_string_literal: true

require 'as_json/version'
require 'as_json/json_encoder'
require 'as_json/scoped_json_mapper'

require 'active_support/concern'
require 'active_support/json'
require 'active_support/core_ext/object'

module AsJson
  extend ActiveSupport::Concern

  class_methods do
    def default_json_attributes
      @default_json_attributes
    end

    def json_with(*attributes, **kargs)
      if @default_json_attributes.blank?
        kargs = { _base: attributes }.merge(kargs)
        @default_json_attributes = kargs
      else
        @default_json_attributes[:_base] += attributes
        @default_json_attributes = AsJson.merge_default_attributes(
          @default_json_attributes, kargs
        )
      end
      ScopedJsonMapper.new self
    end
  end

  def self.merge_default_attributes(existing, new_attributes)
    existing.deep_merge(new_attributes) do |_k, oldval, newval|
      if [oldval, newval].all? { |value| value.is_a?(Array) }
        oldval + newval
      elsif oldval.is_a?(Array) && newval.is_a?(Hash)
        oldval = oldval.map { |k| [k, true] }.to_h
        oldval.deep_merge newval
      elsif newval.is_a?(Array) && oldval.is_a?(Hash)
        newval = newval.map { |k| [k, true] }.to_h
        oldval.deep_merge newval
      else
        newval
      end
    end
  end

  def as_json(opts = {})
    JsonEncoder.new(self, opts).json
  end
end

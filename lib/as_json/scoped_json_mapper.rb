# frozen_string_literal: true

module AsJson
  class ScopedJsonMapper
    def initialize(klass)
      @klass = klass
    end

    def method_missing(name, *args, **kargs)
      @klass.json_with "with_#{name}": kargs.merge(args.map { |key| [key, true] }.to_h)
    end

    def respond_to_missing?
      true
    end
  end
end

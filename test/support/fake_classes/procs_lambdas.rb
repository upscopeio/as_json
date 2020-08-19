# frozen_string_literal: true

require 'as_json'

class ProcsLambdas
  include AsJson

  json_with api_key: -> { '123ABC' },
            full_name: Proc.new { "#{first_name} #{last_name}"}

  def first_name
    'John'
  end

  def last_name
    'Doe'
  end
end

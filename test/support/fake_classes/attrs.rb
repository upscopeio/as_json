# frozen_string_literal: true

require 'as_json'

class Attrs
  include AsJson

  attr_reader :name

  json_with :name, :age, :email

  def initialize(name)
    @name = name
  end

  def age
    23
  end

  def email
    'john@example.com'
  end
end

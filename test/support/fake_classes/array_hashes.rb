# frozen_string_literal: true

require 'as_json'

class ArrayHashes
  include AsJson

  json_with :people, :roles,
            with_options: {
              admin: -> { true }
            }

  def people
    ['John', 'Peter', 'Bruce']
  end

  def roles
    {
      john: 'CEO',
      peter: 'CTO',
      bruce: 'COO'
    }
  end
end

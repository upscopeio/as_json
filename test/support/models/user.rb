# frozen_string_literal: true

class User < ActiveRecord::Base
  include AsJson

  belongs_to :team

  json_with :name, team: [:name]
end

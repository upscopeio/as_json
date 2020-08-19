# frozen_string_literal: true

class Team < ActiveRecord::Base
  include AsJson

  has_many :users, dependent: :destroy

  json_with :name
end

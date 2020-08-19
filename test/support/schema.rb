# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table "teams", force: :true do |t|
    t.string :name

    t.timestamps
  end

  create_table "users", force: true do |t|
    t.string :name
    t.integer :team_id, null: false

    t.timestamps
  end

  add_index :users, :team_id
end

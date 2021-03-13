class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :object_id, null: false
      t.jsonb :attrs, default: {}

      t.timestamps
    end
    add_index :teams, :object_id, unique: true
    add_index :teams, :attrs, using: :gin
  end
end

class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.references :team, null: false, foreign_key: true, index: false
      t.string :name
      t.string :object_id
      t.jsonb :attrs, default: {}

      t.references :user, null: true, foreign_key: true, index: true

      t.timestamps
    end
    add_index :members, [:team_id, :object_id], unique: true
    add_index :members, :attrs, using: :gin
  end
end

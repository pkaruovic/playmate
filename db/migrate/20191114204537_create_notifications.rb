class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :recipient, foreign_key: { to_table: :users }, index: true
      t.references :actor, foreign_key: { to_table: :users }, index: true
      t.string :text, null: false
      t.string :action_path, null: false
      t.boolean :seen, null: false, default: false

      t.timestamps
    end
  end
end

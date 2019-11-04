class UpdatePostAttributes < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :game, :string, null: false
    add_column :posts, :game_type, :string, null: false
    add_column :posts, :players_needed, :integer, null: false
  end
end

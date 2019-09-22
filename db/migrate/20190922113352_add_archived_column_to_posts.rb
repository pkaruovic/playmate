class AddArchivedColumnToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :archived, :boolean, null: false, default: false
  end
end

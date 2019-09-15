class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references :user, index: true
      t.string :description
      t.string :city
      t.string :skill_level
      t.date :date

      t.timestamps
    end
  end
end

class CreatePostsUsersConnection < ActiveRecord::Migration[5.2]
  def change
    create_table :posts_users do |t|
      t.references :user, index: true
      t.references :post, index: true

      t.timestamps
    end
  end
end

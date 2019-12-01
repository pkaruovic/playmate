class CreateJoinRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :join_requests do |t|
      t.references :user, foreign_key: true, index: true
      t.references :post, foreign_key: true, index: true
      t.string :status, null: false, default: "pending"

      t.timestamps
    end
  end
end

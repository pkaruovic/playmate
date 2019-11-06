class AddNameToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :name, :string
    execute "UPDATE users SET name = CONCAT(first_name, ' ', last_name);"
    change_column_null :users, :name, false
  end

  def down
   remove_column :users, :name
  end
end

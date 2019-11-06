class AddPersonalDataColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :birth_date, :date
    add_column :users, :gender, :string
    add_column :users, :biography, :string
  end
end

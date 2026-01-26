class AddGenderToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :gender, :string
  end
end

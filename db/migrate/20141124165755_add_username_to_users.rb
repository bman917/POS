class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :role, :string
    add_column :users, :status, :string, default: 'Active'
  end
end

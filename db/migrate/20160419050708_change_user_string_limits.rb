class ChangeUserStringLimits < ActiveRecord::Migration
  def change
  	change_column :users, :account_create_token, :string, :limit => 255
    change_column :users, :password_reset_token, :string, :limit => 255
    change_column :users, :username, :string, :limit => 255
  end
end

class AddAccountCreateColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :account_create_token, :string
    add_column :users, :account_create_sent_at, :datetime
    add_column :users, :account_create_confirmed_at, :datetime
  end
end

class AddApiTokenToUser < ActiveRecord::Migration
  def up
    add_column :users, :api_token, :binary
  end

  def down
    remove_column :users, :api_token
  end
end

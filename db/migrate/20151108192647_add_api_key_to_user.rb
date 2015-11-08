class AddApiKeyToUser < ActiveRecord::Migration
  def change
    add_column :users, :api_key, :string

    User.all.each do |user|
      user.update api_key: SecureRandom.hex
    end
  end
end

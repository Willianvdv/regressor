class AddTagToResult < ActiveRecord::Migration
  def change
    add_column :results, :tag, :string
  end
end

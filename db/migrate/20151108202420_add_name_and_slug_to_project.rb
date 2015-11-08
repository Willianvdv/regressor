class AddNameAndSlugToProject < ActiveRecord::Migration
  def change
    add_column :projects, :name, :string
    add_column :projects, :slug, :string

    add_index :projects, :slug, unique: true
  end
end

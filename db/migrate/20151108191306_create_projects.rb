class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects, id: :uuid do |t|
      t.references :user, index: true, foreign_key: true, type: :uuid
      t.timestamps null: false
    end
  end
end

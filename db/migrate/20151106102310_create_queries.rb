class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.references :result, index: true, foreign_key: true
      t.string :statement

      t.timestamps
    end
  end
end

class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries, id: :uuid do |t|
      t.references :result, index: true, foreign_key: true, type: :uuid
      t.string :statement

      t.timestamps
    end
  end
end

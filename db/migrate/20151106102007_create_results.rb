class CreateResults < ActiveRecord::Migration
  def change
    create_table :results, id: :uuid do |t|
      t.string :example_location
      t.string :example_name

      t.timestamps
    end
  end
end

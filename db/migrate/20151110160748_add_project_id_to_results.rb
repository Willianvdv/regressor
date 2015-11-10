class AddProjectIdToResults < ActiveRecord::Migration
  def change
    add_reference :results, :project, index: true, foreign_key: true, type: :uuid
  end
end

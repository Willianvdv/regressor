class UniqueConstraintProjectsUsers < ActiveRecord::Migration
  def up
    Project.find_each do |project|
      uniq_users = project.users.uniq
      project.users = []
      project.users = uniq_users
    end

    remove_index :projects_users, [:user_id, :project_id]
    add_index :projects_users, [:user_id, :project_id], unique: true
  end

  def down
    remove_index :projects_users, [:user_id, :project_id]
  end
end

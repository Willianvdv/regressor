class CreateJoinTable < ActiveRecord::Migration
  def up
    create_table :projects_users, id: false do |t|
      t.uuid :user_id
      t.uuid :project_id
      t.index [:user_id, :project_id]
      t.index [:project_id, :user_id]
    end

    Project.find_each do |project|
      project.users << User.find(project.user_id)
      project.save!
    end

    rename_column :projects, :user_id, :creator_id
  end

  def down
    drop_table :projects_users
  end
end

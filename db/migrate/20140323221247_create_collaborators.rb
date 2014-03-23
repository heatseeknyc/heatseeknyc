class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :user_collaborators do |t|
      t.integer :user_id
      t.integer :collaborator_id
      t.integer :permissions
    end
  end
end

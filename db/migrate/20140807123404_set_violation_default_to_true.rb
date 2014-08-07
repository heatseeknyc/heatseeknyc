class SetViolationDefaultToTrue < ActiveRecord::Migration
  def change
    change_column :readings, :violation, :boolean, default: false
  end
end

class SetupSmsAlerts < ActiveRecord::Migration
  def change
    add_column :users, :sms_alert_number, :string
    add_column :users, :summer_user, :boolean, default: false, null: false

    create_table :sms_alerts do |t|
      t.integer :alert_type, null: false
      t.references :users, null: false
      t.timestamps
    end
  end
end

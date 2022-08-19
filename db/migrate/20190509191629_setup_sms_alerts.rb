class SetupSmsAlerts < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :sms_alert_number, :string
    add_column :users, :summer_user, :boolean, default: false, null: false

    create_table :sms_alerts do |t|
      t.string :alert_type, null: false
      t.references :user, null: false
      t.timestamps
    end
  end
end

class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_enum :type, %w[
      return_alert
      rating_reminder
      general_notification
      suspension_notice
    ]

    create_table :messages do |t|
      t.references :user, null: false, foreign_key: true
      t.enum :type, enum_type: 'type', null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end

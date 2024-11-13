class AddRecipientCategoryToMessageRecipients < ActiveRecord::Migration[8.0]
  def up
    create_enum :recipient_category, %w[
      individual
      all_users
      active_loans
    ]

    add_column :message_recipients, :recipient_category, :recipient_category, null: false, default: 'individual'
  end

  def down
    remove_column :message_recipients, :recipient_category

    execute <<-SQL
      DROP TYPE recipient_category;
    SQL
  end
end
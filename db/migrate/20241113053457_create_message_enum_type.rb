class CreateMessageEnumType < ActiveRecord::Migration[8.0]
  def up
    create_enum :message_type, %w[
      information
      warning
      error
    ]

    add_column :messages, :message_type_temp, :message_type, default: 'information', null: false

    remove_column :messages, :type
    rename_column :messages, :message_type_temp, :message_type
  end

  def down
    add_column :messages, :type, :string, null: false

    rename_column :messages, :message_type, :message_type_temp
    remove_column :messages, :message_type_temp

    execute <<-SQL
      DROP TYPE message_type;
    SQL
  end
end
class CreatePqrsEnumAndUpgrade < ActiveRecord::Migration[8.0]
  def up
    create_enum :pqrsf_type, %w[
      petition
      complaint
      claim
      suggestion
      compliment
    ]

    add_column :pqrsfs, :pqrsf_type_temp, :pqrsf_type, default: 'petition', null: false
    add_column :pqrsfs, :pending, :boolean, default: true, null: false

    remove_column :pqrsfs, :type
    rename_column :pqrsfs, :pqrsf_type_temp, :pqrsf_type
  end

  def down
    add_column :pqrsfs, :type, :string, null: false
    add_column :pqrsfs, :date, :datetime, default: -> { 'CURRENT_TIMESTAMP' }, null: false

    rename_column :pqrsfs, :pqrsf_type, :pqrsf_type_temp
    remove_column :pqrsfs, :pqrsf_type_temp

    remove_column :pqrsfs, :pending

    execute <<-SQL
      DROP TYPE pqrsf_type;
    SQL
  end
end
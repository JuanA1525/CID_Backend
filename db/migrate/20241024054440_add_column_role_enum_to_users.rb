class AddColumnRoleEnumToUsers < ActiveRecord::Migration[8.0]
  def change
    # Crear el tipo de enum 'role'
    create_enum :role, %w[
      admin
      borrower
    ]

    # Agregar la columna 'role' a la tabla 'users'
    add_column :users, :role, :enum, enum_type: :role, default: 'borrower', null: false
  end
end

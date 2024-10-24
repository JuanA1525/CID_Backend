class RenameTypeColumnInEquipment < ActiveRecord::Migration[8.0]
  def change
        # Renombrar el enum en la base de datos
        execute <<-SQL
        ALTER TYPE type RENAME TO equipment_type;
      SQL

      # Renombrar la columna en la tabla equipment
      rename_column :equipment, :type, :equipment_type
  end
end

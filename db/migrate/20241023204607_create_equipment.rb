class CreateEquipment < ActiveRecord::Migration[8.0]
  def change
    create_table :equipment do |t|
      t.integer :equipment_type, null: false
      t.integer :condition, null: false, default: 0
      t.boolean :available, null: false, default: true
      t.references :institution, null: false, foreign_key: true
      t.references :sport, null: false, foreign_key: true

      t.timestamps
    end
  end
end

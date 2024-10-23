class CreateEquipmentStateHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :equipment_state_histories do |t|
      t.references :equipment, null: false, foreign_key: true
      t.integer :previous_condition, null: false
      t.integer :new_condition, null: false

      t.timestamps
    end
  end
end

class CreatePqrsfs < ActiveRecord::Migration[8.0]
  def change
    create_table :pqrsfs do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :pqrsf_type, null: false
      t.text :description, null: false
      t.datetime :date, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end
  end
end

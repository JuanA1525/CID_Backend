class CreateLoans < ActiveRecord::Migration[8.0]
  def change
    create_table :loans do |t|
      t.references :user, null: false, foreign_key: true
      t.references :equipment, null: false, foreign_key: true
      t.datetime :loan_date, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :return_due_date, null: false
      t.datetime :return_date
      t.integer :status, null: false, default: 0
      t.text :remark

      t.timestamps
    end
  end
end

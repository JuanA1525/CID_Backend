class CreateLoans < ActiveRecord::Migration[8.0]
  def change
    create_enum :status, %w[
      active
      returned
      expired
    ]

    create_table :loans do |t|
      t.references :user, null: false, foreign_key: true
      t.references :equipment, null: false, foreign_key: true
      t.datetime :loan_date, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :return_due_date, null: false
      t.datetime :return_date
      t.enum :status, enum_type: 'status', default: 'active', null: false
      t.text :remark

      t.timestamps
    end
  end
end

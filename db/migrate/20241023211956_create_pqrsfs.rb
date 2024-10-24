class CreatePqrsfs < ActiveRecord::Migration[8.0]
  def change
    create_enum :type, %w[
      request
      complaint
      claim
      suggestion
      compliment
    ]

    create_table :pqrsfs do |t|
      t.references :user, null: false, foreign_key: true
      t.enum :type, enum_type: 'type', null: false
      t.text :description, null: false
      t.datetime :date, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end
  end
end

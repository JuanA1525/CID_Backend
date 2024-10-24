class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_enum :status, %w[
      active
      inactive
      suspended
    ]

    create_enum :occupation, %w[
      student
      visitor
      graduated
      employee
    ]

    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.enum :occupation, enum_type: 'occupation', default: 'student', null: false
      t.enum :status, enum_type: 'status', default: 'active', null: false
      t.boolean :notification_pending, default: false
      t.references :institution, null: false, foreign_key: true

      t.timestamps
    end
  end
end
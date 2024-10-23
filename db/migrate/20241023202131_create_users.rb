class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer :occupation, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.boolean :notification_pending, default: false
      t.references :institution, null: false, foreign_key: true

      t.timestamps
    end
  end
end

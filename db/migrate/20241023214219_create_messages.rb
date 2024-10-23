class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :message_type, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end

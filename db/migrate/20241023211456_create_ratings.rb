class CreateRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :ratings do |t|
      t.references :loan, null: false, foreign_key: true
      t.integer :score, null: false
      t.text :comment

      t.timestamps
    end
  end
end

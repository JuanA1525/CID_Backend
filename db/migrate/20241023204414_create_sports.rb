class CreateSports < ActiveRecord::Migration[8.0]
  def change
    create_table :sports do |t|
      t.string :name, null: false
      t.string :description, null: false

      t.timestamps
    end
  end
end

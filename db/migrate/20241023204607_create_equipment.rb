class CreateEquipment < ActiveRecord::Migration[8.0]
  def change
    create_enum :type, %w[
      helmets
      knee_pads
      elbow_pads
      vests
      protectors
      weights
      dumbbells
      elastic_bands
      mat
      rope
      medicine_balls
      nets
      baskets
      goals
      hoops
      balls
      rackets
      sticks
      boards
      masks
      gloves
    ]

    create_enum :condition, %w[
      perfect
      good
      acceptable
      fair
      bad
      unusable
    ]

    create_table :equipment do |t|
      t.enum :type, enum_type: 'type', null: false
      t.enum :condition, enum_type: 'condition', default: 'perfect', null: false
      t.boolean :available, null: false, default: true
      t.references :institution, null: false, foreign_key: true
      t.references :sport, null: false, foreign_key: true

      t.timestamps
    end
  end
end

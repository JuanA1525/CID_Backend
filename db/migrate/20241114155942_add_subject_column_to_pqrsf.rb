class AddSubjectColumnToPqrsf < ActiveRecord::Migration[8.0]
  def up
    add_column :pqrsfs, :subject, :string
  end

  def down
    remove_column :pqrsfs, :subject
  end
end

class AddSubjectColumnToPqrsf < ActiveRecord::Migration[8.0]
  def change
    add_column :pqrsfs, :subject, :string
  end
end

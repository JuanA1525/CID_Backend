class MakeSubjectNotNullInPqrsfs < ActiveRecord::Migration[8.0]
  def change
    change_column_null :pqrsfs, :subject, false
  end
end

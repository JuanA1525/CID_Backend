class HacerInstitucionDefault1 < ActiveRecord::Migration[8.0]
  def change
    change_column_default :equipment, :institution_id, 1
    change_column_null :equipment, :institution_id, true
  end
end

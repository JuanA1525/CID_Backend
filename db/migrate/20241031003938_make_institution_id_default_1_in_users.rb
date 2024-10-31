class MakeInstitutionIdDefault1InUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :institution_id, 1
  end
end

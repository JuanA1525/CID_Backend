class CreateLoanStatusEnumForLoan < ActiveRecord::Migration[8.0]
  def change
    # Crear el tipo de enum en PostgreSQL
    create_enum :loan_status, %w[
      active
      returned
      expired
    ]

    add_column :loans, :loan_status_temp, :loan_status, default: 'active', null: false

    execute <<-SQL
      UPDATE loans
      SET loan_status_temp = CASE status
        WHEN 'active' THEN 'active'::loan_status
        WHEN 'inactive' THEN 'active'::loan_status
        WHEN 'suspended' THEN 'active'::loan_status
        ELSE 'active'::loan_status
      END
    SQL

    remove_column :loans, :status

    rename_column :loans, :loan_status_temp, :status
  end
end

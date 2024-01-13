class AddPayoutDateToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :payout_date, :string
    add_column :groups, :monthly_sallary, :integer
  end
end

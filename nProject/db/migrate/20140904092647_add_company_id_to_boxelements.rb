class AddCompanyIdtoBoxelements < ActiveRecord::Migration
  def up
  	add_column :boxelements, :company_id, :integer
  end

  def down
  	remove_column :boxelements, :company_id
  end
end


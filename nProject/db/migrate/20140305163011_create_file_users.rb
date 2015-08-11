class CreateFileUsers < ActiveRecord::Migration
  def up
  	create_table :fileusers do |t|
  		t.string :user_id
  		t.integer :attachment_id
  		t.integer :permission_flag

  	end
  end

  def down
  	drop_table :fileusers
  end
end

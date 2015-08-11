class AddProjectIssueIdToIssues < ActiveRecord::Migration
  def up
  	add_column :issues, :project_issue_id, :integer
  end
  
  def down
    remove_column :issues, :project_issue_id
  end

end

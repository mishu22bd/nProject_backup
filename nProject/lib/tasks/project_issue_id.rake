namespace :project do
  task :project_issue_id => :environment do
    projects = Project.all
    projects.each do |project|
      project_issues = project.issues.project_wise_issues
      project_tasks  = project.issues.project_wise_tasks
      project_wise_issue_id = 1
      puts "Updating ::Issues:: on Project:: #{project.id}---> #{project.issues.empty? ? 'No Issue Found!!!' : '...Updating Issues'}"
      project_issues.each do |issue|
        issue.update_column(:project_issue_id, project_wise_issue_id)
        puts "--ID->#{issue.id}<--P Issue ID--->#{issue.project_issue_id}<--Project-->#{issue.project_id}<--Tracker--->#{issue.tracker_id}"
        project_wise_issue_id = project_wise_issue_id + 1
      end

      project_wise_task_id = 1
      puts "Updating ::Tasks:: on Project:: #{project.id}---> #{project.issues.empty? ? 'No Task Found!!!' : '...Updating Tasks'}"
      project_tasks.each do |issue|
        issue.update_column(:project_issue_id, project_wise_task_id)
        puts "--ID->#{issue.id}<--P Issue ID--->#{issue.project_issue_id}<--Project-->#{issue.project_id}<--Tracker--->#{issue.tracker_id}"
        project_wise_task_id = project_wise_task_id + 1
      end
    end
  end
end
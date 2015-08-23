class Reminder


  def initialize
	  @porject = nil
	  @due_date = Date.today + 3
  end
  
  def process
	  @projects = Project.find.all
	  @projects.each do |p|
      issues = Issue.find(:all,
                            :conditions => [ 'due_date < ? and due_date >= ? and project_id = ? ', 
                                            @due, Date.today, p.id])
      issues.each do |i|
        ReminderMailer.send_reminder_email( i.assigned_to_id, i.project_id, i.updated_on, i.author_id)
      end

	 end
  end 
end

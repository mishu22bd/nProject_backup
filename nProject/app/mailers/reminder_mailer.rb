class ReminderMailer < ActionMailer::Base
  default from: "mishu22bd@gmail.com"

  def send_reminder_email(assigned_id, project_id)
    @assigned_id = assigned_id
    @project_id = project_id


    @user = User.find(@assigned_id)
    mail(to: @user.email, subject: 'This is Issue Reminder Mail')

  end
end

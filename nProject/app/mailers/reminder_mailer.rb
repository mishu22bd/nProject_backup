class ReminderMailer < ActionMailer::Base
  
  default from: "sayem@nksoft.com"

    def send_reminder_email(i.assigned_to_id, i.project_id, i.updated_on, i.author_id)
     @user = i.assigned_to_id
    @project = i.project_id

    mail(to: @user.email, subject: 'This is a Reminder Mail')
  end
end


class InviteMailer < ActionMailer::Base
  


  default from: "webweaver.mdrezaur@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invite_mailer.invitation_to_member.subject
  #
  def invitation_to_member(mailList)
    @greeting = "Hi"
    @firstName
    @lastName
    @meetingTitle
    @meetingDetails
    @meetingStartTime
    @meetingDuration
    @meetingCoordinatorFirstName
    @meetingCoordinatorLastName  
    @meetingId
    @mailAddress 
    @userId

    mailList.each do |m|
  
    @firstName = User.where(mail: m).pluck(:firstname) 

    @lastName = User.where(mail: m).pluck(:lastname) 
    @userId =  User.where(mail: m).pluck(:id)
    @meetingCoordinatorFirstName = User.current.firstname
    @meetingCoordinatorLastName = User.current.lastname
    @meetingTitle = Invite.last.name
    @meetingDetails = Invite.last.description
    @meetingStartTime = Invite.last.start_from
    @meetingDuration = Invite.last.duration
    @meetingId = Invitee.last.id
    @mailAddress = m
    puts "hello world"
    puts @userId
      mail(:to => m, :subject => "New Meeing Invitation").deliver
    puts m
  end
end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invite_mailer.invitation_to_non_member.subject
  #
  def invitation_to_non_member
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end

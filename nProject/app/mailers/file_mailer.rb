class FileMailer < ActionMailer::Base
  default from: "nproject@nksoft.com"

  def send_email_file_user(fileuser, file, id)
    @file = file
    #@file_id = id
    filedata = LinkedFile.where(boxelement_id: id).first
    @filename = filedata.filename
    @file_id = filedata.id
    @user_file = User.find(fileuser)
    @user = @user_file.name
    puts @user_file.mail
     
    mail to: @user_file.mail, subject: " A new file #{@filename} is added to Knowledge Management. "
    
  end
  
end

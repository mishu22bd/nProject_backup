# Redmine - project management software
# Copyright (C) 2006-2013  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.


class FilesController < ApplicationController
  menu_item :files

  before_filter :find_project_by_project_id
  before_filter :authorize, :except => [:changeDescription,:test123up,:visibility]

  helper :sort
  include SortHelper

  def index
    sort_init 'filename', 'asc'
    sort_update 'filename' => "#{Attachment.table_name}.filename",
                'created_on' => "#{Attachment.table_name}.created_on",
                'size' => "#{Attachment.table_name}.filesize",
                'downloads' => "#{Attachment.table_name}.downloads"

    @containers = [ Project.includes(:attachments).reorder(sort_clause).find(@project.id)]
    @containers += @project.versions.includes(:attachments).reorder(sort_clause).all.sort.reverse
    render :layout => !request.xhr?
  end

  def new
    @versions = @project.versions.sort
    # 1.times {@project.fileusers.build}
   
  end

  def edit 
     puts 'in edit method'
    
  end
  def create
    container = (params[:version_id].blank? ? @project : @project.versions.find_by_id(params[:version_id]))
    attachments = Attachment.attach_files(container, params[:attachments])
    render_attachment_warning_if_needed(container)


      puts 'in create method'
      puts ' hello'
      members = Member.where(project_id: @project.id).pluck(:user_id) #find the users of the project
      puts members
      puts  'hello'
#      puts attachments.assoc(:files) 
     # attachments.each {|key, value| puts "#{key} is #{value}" }
      #puts attachments
      a =  attachments[:files].to_s
      b = a.scan(/\sid: (\d+)/).flatten


 #     attachments.each do |a|
  #    puts   a.assoc(:fdsfd) 
   #   end



# attachments.each do |a|
#   puts a[:files]
#end




      members.each do |m|
              b.each do |at|
                    f = Fileuser.new
                    f.user_id = m  
                    f.attachment_id = at
                    f.permission_flag = 1 # 1 means read 
                    f.save  
              end

      end




    if !attachments.empty? && !attachments[:files].blank? && Setting.notified_events.include?('file_added')
    

# codes for visibility

#      members=[]
 #   members = Member.all
#    members.each do |m|
      #members<< Member.where(user_id: @project.id)
  #  end  
      
      #puts members

    #f = Fileuser.new
    #f.user_id = 







#visibility code end 







      Mailer.attachments_added(attachments[:files]).deliver
    end

    
    redirect_to project_files_path(@project)
  end



  def update
     a = Attachment.find(params[:description])
     puts 'in the update method'
     end

def changeDescription 
      a = Attachment.find(params[:f_id])
      #      a.update_attributes(
       #   :description => "uppeddddd"
       # )
      puts 'hello test'

#      redirect_to project_files_path(@project)
 
end


def visibility

end



def show
  end


end

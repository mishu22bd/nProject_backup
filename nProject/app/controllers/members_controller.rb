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

class MembersController < ApplicationController
  model_object Member
  before_filter :find_model_object, :except => [:index, :create, :autocomplete]
  before_filter :find_project_from_association, :except => [:index, :create, :autocomplete]
  before_filter :find_project_by_project_id, :only => [:index, :create, :autocomplete]
  before_filter :authorize
  accept_api_auth :index, :show, :create, :update, :destroy

  def index
    @offset, @limit = api_offset_and_limit
    @member_count = @project.member_principals.count
    @member_pages = Paginator.new @member_count, @limit, params['page']
    @offset ||= @member_pages.offset
    @members =  @project.member_principals.all(
      :order => "#{Member.table_name}.id",
      :limit  =>  @limit,
      :offset =>  @offset
    )

    respond_to do |format|
      format.html { head 406 }
      format.api
    end
  end

  def show
    respond_to do |format|
      format.html { head 406 }
      format.api
    end
  end

  def create
    members = []
    if params[:membership]
      if params[:membership][:user_ids]
        attrs = params[:membership].dup
        user_ids = attrs.delete(:user_ids)
        user_ids.each do |user_id|
          members << Member.new(:role_ids => params[:membership][:role_ids], :user_id => user_id)
        end
      else
        members << Member.new(:role_ids => params[:membership][:role_ids], :user_id => params[:membership][:user_id])
      end
      @project.members << members
      
     


    #  permitted_users = []
      
     # members.each do|m|
      #  if User.where(id: m).pluck(:login)==[]
       #     gusers = GroupsUser.where(group_id: m).pluck(:user_id) 
#
 #           gusers.each do |guser|
  #            permitted_users<<guser
   #         end
    #    else
     #     permitted_users<<m
      #  end
      #end

      # the following code is responsible for adding new memners in the file permission table  
     







      members.each do |m|
          attachments = Boxelement.where(project_id: @project.id) # finding attachment files of the projects from boxelements table




          attachments.each do|a| #iterate each attachment enrey

            if  a.private_flag == 0 # check whether the permission flag is disabled  
                  new_user_permission_row = Fileuser.new
                  new_user_permission_row.user_id = m.user_id 
                  new_user_permission_row.attachment_id = a.id 
                  new_user_permission_row.permission_flag  = 1 
                  new_user_permission_row.save
             else
                  new_user_permission_row = Fileuser.new
                  new_user_permission_row.user_id = m.user_id 
                  new_user_permission_row.attachment_id = a.id 
                  new_user_permission_row.permission_flag  = 0 
                  new_user_permission_row.save
             end   



              end 
         end 
   


    end

    respond_to do |format|
      format.html { redirect_to_settings_in_projects }
      format.js { @members = members }
      format.api {
        @member = members.first
        if @member.valid?
          render :action => 'show', :status => :created, :location => membership_url(@member)
        else
          render_validation_errors(@member)
        end
      }
    end
  end

  def update
    if params[:membership]
      @member.role_ids = params[:membership][:role_ids]
    end
    saved = @member.save
    respond_to do |format|
      format.html { redirect_to_settings_in_projects }
      format.js
      format.api {
        if saved
          render_api_ok
        else
          render_validation_errors(@member)
        end
      }
    end
  end

  def destroy
    if request.delete? && @member.deletable?
      
      puts @member
      @member.destroy
      # the following code is responsible for destroying data in the fileusers table after remi=oving user from project
      attachements = Boxelement.where(project_id: @member.project_id) # iterate boxelements table
      
      attachements.each do|a|
      files = Fileuser.where(user_id: @member.user_id, attachment_id: a.id)
       

      files.each do |f|
            f.destroy # destroy relevant fileuser entry 
      end
 end







    end
    respond_to do |format|
      format.html { redirect_to_settings_in_projects }
      format.js
      format.api {
        if @member.destroyed?
          render_api_ok
        else
          head :unprocessable_entity
        end
      }
    end
  end

  def autocomplete
    respond_to do |format|
      format.js
    end
  end

  private

  def redirect_to_settings_in_projects
    redirect_to settings_project_path(@project, :tab => 'members')
  end
end

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

class ActivitiesController < ApplicationController
  menu_item :activity
  before_filter :find_optional_project
  accept_rss_auth :index

  def index

    @days = Setting.activity_days_default.to_i
    #@days = 30
    @author = (params[:user_id].blank? ? nil : User.active.find(params[:user_id]))
    if params[:from]
      begin
         @date_to = params[:from].to_date + 1;
      rescue;
      end
    end

    @date_to ||= Date.today + 1
    @date_from = @date_to - @days

    issues = Issue.where(project_id: @project.id)
    @journals = Journal.includes(:user, :details).where(:journalized_id => issues.collect(&:id), :journalized_type => "Issue")
                .where(:created_on => @date_from.beginning_of_day..@date_to.end_of_day)
                .reorder("#{Journal.table_name}.id DESC").all


    respond_to do |format|
      format.html {
        render :layout => false if request.xhr?
      }
    end

  rescue ActiveRecord::RecordNotFound
    render_404
  end

  private

  # TODO: refactor, duplicated in projects_controller
  def find_optional_project
    return true unless params[:id]
    @project = Project.find(params[:id])
    authorize
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end

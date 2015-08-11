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

class WelcomeController < ApplicationController
  before_filter :require_login
  caches_action :robots
  helper :issues
  helper :projects
  helper :queries
  include QueriesHelper
  helper :sort
  include SortHelper
  def index
    @news = News.latest User.current
    @projects = Project.latest User.current
    @users = User.all

    @issues  = Issue.order("created_on DESC").all

    @allFiles = Attachment.all.reverse  
    
   # @callers = Caller.all
    @year ||= Date.today.year #returns 2013
  
    @month ||= Date.today.month #returns 12
    @calendarLocal = Redmine::Helpers::Calendar.new(Date.civil(@year,@month), current_language, :week)
    print @calendarLocal
    retrieve_query
    @query.group_by = nil
    if @query.valid?
      events = []
      events += @query.issues(:include => [:tracker, :assigned_to, :priority],
                              :conditions => ["((start_date BETWEEN ? AND ?) OR (due_date BETWEEN ? AND ?))", @calendarLocal.startdt, @calendarLocal.enddt, @calendarLocal.startdt, @calendarLocal.enddt]
                              )
      events += @query.versions(:conditions => ["effective_date BETWEEN ? AND ?", @calendarLocal.startdt, @calendarLocal.enddt])#

   @calendarLocal.events = events
  end
end
  def robots
    @projects = Project.all_public.active
    render :layout => false, :content_type => 'text/plain'
  end
end

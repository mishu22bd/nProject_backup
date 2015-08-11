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

class Reminder < ActiveRecord::Base
 
  def initialize
    @project = nil
    @due_date = Date.today + 3
  end
  def process
    @projects = Project.find.all
    @projects.each do |p|
      issues = Issue.find(:all,
                            :conditions => [ 'due_date < ? and due_date >= ? and project_id = ? ', 
                                            @due_date, Date.today, p.id]
      issues.each do |i|
        ReminderMailer.send_reminder_email(i.assigned_to_id, i.project_id)
      end

   end
  end 
end


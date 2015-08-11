# encoding: utf-8
#
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

module ActivitiesHelper
  include ApplicationHelper
  def sort_activity_events(events)
    events_by_group = events.group_by(&:event_group)
    sorted_events = []
    events.sort {|x, y| y.event_datetime <=> x.event_datetime}.each do |event|
      if group_events = events_by_group.delete(event.event_group)
        group_events.sort {|x, y| y.event_datetime <=> x.event_datetime}.each_with_index do |e, i|
          sorted_events << [e, i > 0]
        end
      end
    end
    sorted_events
  end

  # Returns the textual representation of a journal details
  # as an array of strings
  def details_to_strings(details, no_html=false, options={})
    options[:only_path] = (options[:only_path] == false ? false : true)
    strings = []
    values_by_field = {}
    details.each do |detail|
      if detail.property == 'cf'
        field = detail.custom_field
        if field && field.multiple?
          values_by_field[field] ||= {:added => [], :deleted => []}
          if detail.old_value
            values_by_field[field][:deleted] << detail.old_value
          end
          if detail.value
            values_by_field[field][:added] << detail.value
          end
          next
        end
      end
      strings << show_detail(detail, no_html, options)
    end
    values_by_field.each do |field, changes|
      detail = JournalDetail.new(:property => 'cf', :prop_key => field.id.to_s)
      detail.instance_variable_set "@custom_field", field
      if changes[:added].any?
        detail.value = changes[:added]
        strings << show_detail(detail, no_html, options)
      elsif changes[:deleted].any?
        detail.old_value = changes[:deleted]
        strings << show_detail(detail, no_html, options)
      end
    end
    strings
  end

  # Returns the textual representation of a single journal detail
  def show_detail(detail, no_html=false, options={})
    multiple = false
    case detail.property
      when 'attr'
        field = detail.prop_key.to_s.gsub(/\_id$/, "")
        label = l(("field_" + field).to_sym)
        case detail.prop_key
          when 'due_date', 'start_date'
            value = format_date(detail.value.to_date) if detail.value
            old_value = format_date(detail.old_value.to_date) if detail.old_value

          when 'project_id', 'status_id', 'tracker_id', 'assigned_to_id',
              'priority_id', 'category_id', 'fixed_version_id'
            value = find_name_by_reflection(field, detail.value)
            old_value = find_name_by_reflection(field, detail.old_value)

          when 'estimated_hours'
            value = "%0.02f" % detail.value.to_f unless detail.value.blank?
            old_value = "%0.02f" % detail.old_value.to_f unless detail.old_value.blank?

          when 'parent_id'
            label = l(:field_parent_issue)
            value = "##{detail.value}" unless detail.value.blank?
            old_value = "##{detail.old_value}" unless detail.old_value.blank?

          when 'is_private'
            value = l(detail.value == "0" ? :general_text_No : :general_text_Yes) unless detail.value.blank?
            old_value = l(detail.old_value == "0" ? :general_text_No : :general_text_Yes) unless detail.old_value.blank?
        end
      when 'cf'
        custom_field = detail.custom_field
        if custom_field
          multiple = custom_field.multiple?
          label = custom_field.name
          value = format_value(detail.value, custom_field.field_format) if detail.value
          old_value = format_value(detail.old_value, custom_field.field_format) if detail.old_value
        end
      when 'attachment'
        label = l(:label_attachment)
      when 'relation'
        if detail.value && !detail.old_value
          rel_issue = Issue.visible.find_by_id(detail.value)
          value = rel_issue.nil? ? "#{l(:label_issue)} ##{detail.value}" :
              (no_html ? rel_issue : link_to_issue(rel_issue, :only_path => options[:only_path]))
        elsif detail.old_value && !detail.value
          rel_issue = Issue.visible.find_by_id(detail.old_value)
          old_value = rel_issue.nil? ? "#{l(:label_issue)} ##{detail.old_value}" :
              (no_html ? rel_issue : link_to_issue(rel_issue, :only_path => options[:only_path]))
        end
        label = l(detail.prop_key.to_sym)
    end
    call_hook(:helper_issues_show_detail_after_setting,
              {:detail => detail, :label => label, :value => value, :old_value => old_value})

    label ||= detail.prop_key
    value ||= detail.value
    old_value ||= detail.old_value

    unless no_html
      label = content_tag('strong', label)
      old_value = content_tag("i", h(old_value)) if detail.old_value
      if detail.old_value && detail.value.blank? && detail.property != 'relation'
        old_value = content_tag("del", old_value)
      end
      if detail.property == 'attachment' && !value.blank? && atta = Attachment.find_by_id(detail.prop_key)
        # Link to the attachment if it has not been removed
        value = link_to_attachment(atta, :download => true, :only_path => options[:only_path])
        if options[:only_path] != false && atta.is_text?
          value += link_to(
              image_tag('magnifier.png'),
              :controller => 'attachments', :action => 'show',
              :id => atta, :filename => atta.filename
          )
        end
      else
        value = content_tag("i", h(value)) if value
      end
    end

    if detail.property == 'attr' && detail.prop_key == 'description'
      s = l(:text_journal_changed_no_detail, :label => label)
      unless no_html
        diff_link = link_to 'diff',
                            {:controller => 'journals', :action => 'diff', :id => detail.journal_id,
                             :detail_id => detail.id, :only_path => options[:only_path]},
                            :title => l(:label_view_diff)
        s << " (#{ diff_link })"
      end
      s.html_safe
    elsif detail.value.present?
      case detail.property
        when 'attr', 'cf'
          if detail.old_value.present?
            l(:text_journal_changed, :label => label, :old => old_value, :new => value).html_safe
          elsif multiple
            l(:text_journal_added, :label => label, :value => value).html_safe
          else
            l(:text_journal_set_to, :label => label, :value => value).html_safe
          end
        when 'attachment', 'relation'
          l(:text_journal_added, :label => label, :value => value).html_safe
      end
    else
      l(:text_journal_deleted, :label => label, :old => old_value).html_safe
    end
  end

  # Find the name of an associated record stored in the field attribute
  def find_name_by_reflection(field, id)
    unless id.present?
      return nil
    end
    association = Issue.reflect_on_association(field.to_sym)
    if association
      record = association.class_name.constantize.find_by_id(id)
      if record
        record.name.force_encoding('UTF-8') if record.name.respond_to?(:force_encoding)
        return record.name
      end
    end
  end
end

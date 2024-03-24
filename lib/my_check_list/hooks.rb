module MyCheckList
  class Hooks < Redmine::Hook::ViewListener
    
    def view_issues_show_description_bottom(context = {})
      checklist = []
      if context[:issue].id.present?
        checklist = CheckItem.where(issue: context[:issue]).order(:order_num)
      end
      context[:controller].send('render_to_string',{
                :partial => 'my_check_list/show_checklist_form',
                :locals => {context: context, checklist: checklist}
      })
    end

    def view_issues_form_details_bottom(context = {})
      checklist = []
      if context[:issue].id.present?
        checklist = CheckItem.where(issue: context[:issue]).order(:order_num)
      end
      context[:controller].send('render_to_string',{
                :partial => 'my_check_list/edit_checklist_form',
                :locals => {context: context, checklist: checklist}
      })
    end
    
    def controller_issues_new_after_save(context={})
      items = items_params(context) 
      issue = context[:issue]
      save_checklist(items, issue)
    end

    def controller_issues_edit_after_save(context={})
      items = items_params(context) 
      issue = context[:issue]
      CheckItem.destroy_by(issue: issue)
      save_checklist(items, issue)
    end
    
    private
    
    def save_checklist(items, issue)
      edit_items = []
      items.each_with_index do |item, index|
        check_item = CheckItem.new(item)
        check_item.issue = issue
        check_item.order_num = index
        edit_items << check_item
      end
      edit_items.each do |edit_item|
        edit_item.save
      end
      issue.done_ratio = calc_progress(edit_items, issue)
      if issue.done_ratio == 100
        issue.status_id = 5
      end
      issue.save
    end
    
    def calc_progress(items, issue)
      items_completed = items.filter{ |item| item.is_done }
      total = issue.children.length + items.length

      subtasks = issue.children
      subtasks_completed = subtasks.filter{|subtask| subtask.done_ratio == 100 || subtask.status_id == 5}

      (subtasks_completed.length.to_f + items_completed.length.to_f) / total.to_f * 100.0
    end

    def items_params(context={})
      if context[:params][:items].present?
        context[:params].require(:items).map do |item|
          item.permit(:text, :is_done) if !item[:text].blank?
        end.compact
      else
        {}
      end
    end
    
  end
end
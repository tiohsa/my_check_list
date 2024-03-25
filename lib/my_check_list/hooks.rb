module MyCheckList
  class Hooks < Redmine::Hook::ViewListener
    include CheckListHelper

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
      # update_issue_done_ratio(issue)
    end

    def controller_issues_edit_after_save(context={})
      items = items_params(context)
      issue = context[:issue]
      CheckItem.destroy_by(issue: issue)
      save_checklist(items, issue)
      update_issue_done_ratio(issue)
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

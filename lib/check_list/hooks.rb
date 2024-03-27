module CheckList
  class Hooks < Redmine::Hook::ViewListener
    include CheckListHelper

    def view_issues_show_description_bottom(context = {})
      checklist = []
      if context[:issue].id.present?
        checklist = CheckItem.where(issue: context[:issue]).order(:order_num)
      end
      context[:controller].send('render_to_string',{
                :partial => 'check_list/show_checklist_form',
                :locals => {context: context, checklist: checklist}
      })
    end

    def view_issues_form_details_bottom(context = {})
      checklist = []
      if context[:issue].id.present?
        checklist = CheckItem.where(issue: context[:issue]).order(:order_num)
      end
      context[:controller].send('render_to_string',{
                :partial => 'check_list/edit_checklist_form',
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

      delete_item_ids = get_delete_ids(items, issue)
      delete_item_ids.each do |delete_item_id|
        CheckItem.destroy(delete_item_id)
      end

      save_checklist(items, issue)
      update_issue_done_ratio(issue)
      update_parent_progress(issue)
    end

    private

    def get_delete_ids(items, issue)
      registered_checklist = CheckItem.where(issue: issue)
      registered_check_item_ids = registered_checklist.map do |registered_check_item|
        registered_check_item.id
      end
      item_ids = items.map do |item|
        item[:id].to_i
      end.compact
      delete_ids = registered_check_item_ids - item_ids
      delete_ids
    end

    def save_checklist(items, issue)
      edit_items = []
      items.each_with_index do |item, index|
        check_item = CheckItem.find_by(id: item[:id].to_i)
        if !check_item.present?
          check_item = CheckItem.new(item)
        end
        check_item.issue = issue
        check_item.text = item[:text]
        check_item.is_done = item[:is_done]
        check_item.man_hours = item[:man_hours]
        check_item.order_num = index
        edit_items << check_item
      end
      edit_items.each do |edit_item|
        edit_item.save!
      end
    end

    def items_params(context={})
      if context[:params][:items].present?
        context[:params].require(:items).map do |item|
          item.permit(:text, :is_done, :id, :man_hours) if !item[:text].blank?
        end.compact
      else
        {}
      end
    end

  end
end

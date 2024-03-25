class CheckListController < ApplicationController

  def update_progress
    id = params[:id]
    order_num = params[:order_num]
    is_doen = params[:is_done].downcase == "true"
    check_item = CheckItem.find_by(issue: id, order_num: order_num)
    check_item.is_done = is_doen
    check_item.save
    update_issue_done_ratio(Issue.find(id))
    render json: { check_item: check_item }
  end

  private

  def update_issue_done_ratio(issue)
    items = CheckItem.where(issue: issue)
    issue.done_ratio = calc_progress(items, issue)
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
end

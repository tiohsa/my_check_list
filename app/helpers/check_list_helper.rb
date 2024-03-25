module CheckListHelper
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

  def update_parent_progress(issue)
      while issue.present?
        update_issue_done_ratio(issue)
        issue = issue.parent
      end
    end
end

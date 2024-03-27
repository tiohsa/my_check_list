class CheckListController < ApplicationController
  include CheckListHelper

  def update_progress
    id = params[:id]
    order_num = params[:order_num]
    is_doen = params[:is_done].downcase == "true"
    man_hours = params[:man_hours]
    check_item = CheckItem.find_by(issue: id, order_num: order_num)
    check_item.is_done = is_doen
    check_item.man_hours = man_hours
    check_item.save!
    update_issue_done_ratio(Issue.find(id))
    render json: { check_item: check_item }
  end

end

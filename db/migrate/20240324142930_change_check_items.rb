class ChangeCheckItems  < ActiveRecord::Migration[6.1]
  def change
    # remove_column :check_items, :issue_id
    add_reference :check_items, :issue, foreign_key: true
  end
end

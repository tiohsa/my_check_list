class CheckItems < ActiveRecord::Migration[6.1]
  def change
    add_column :check_items, :man_hours, :float
    add_column :check_items, :start_datetime, :datetime
    add_column :check_items, :end_datetime, :datetime
  end
end

class CreateCheckItems < ActiveRecord::Migration[6.1]
  def change
    create_table :check_items do |t|
      t.references :issue, foreign_key: true, type: :integer
      t.integer :order_num
      t.string :text
      t.boolean :is_done, default: false

      t.timestamps
    end
  end
end

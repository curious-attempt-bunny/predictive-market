class CreatePurchase < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.belongs_to :user
      t.belongs_to :outcome
      t.integer    :quantity
      t.float      :cost
      t.timestamps
    end
  end
end

class CreateHoldings < ActiveRecord::Migration
  def change
    create_table :holdings do |t|
      t.belongs_to :user, index: true
      t.references :outcome, index: true
      t.integer :quantity, null: false
      t.timestamp
    end
  end
end

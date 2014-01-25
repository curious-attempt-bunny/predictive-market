class AddBalanceToUser < ActiveRecord::Migration
  def change
    add_column :users, :balance, :float, null: false, default: 100
  end
end

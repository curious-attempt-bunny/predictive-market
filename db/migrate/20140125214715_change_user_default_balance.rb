class ChangeUserDefaultBalance < ActiveRecord::Migration
  def change
    change_column_default :users, :balance, 10000
  end
end

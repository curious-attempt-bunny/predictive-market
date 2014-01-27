class AddCorrectToOutcome < ActiveRecord::Migration
  def change
    add_column :outcomes, :correct, :boolean
  end
end

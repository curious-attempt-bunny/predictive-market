class AddResolvedToOutcomes < ActiveRecord::Migration
  def change
    add_column :outcomes, :resolved, :boolean, default: false
  end
end

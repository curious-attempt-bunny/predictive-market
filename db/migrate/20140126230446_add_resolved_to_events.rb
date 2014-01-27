class AddResolvedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :resolved, :boolean, default: false
  end
end

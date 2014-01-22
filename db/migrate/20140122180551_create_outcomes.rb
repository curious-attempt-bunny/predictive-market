class CreateOutcomes < ActiveRecord::Migration
  def change
    create_table :outcomes do |t|
      t.string :name
      t.references :event, index: true

      t.timestamps
    end
  end
end

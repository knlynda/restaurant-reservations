class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.integer :number, null: false, index: true

      t.timestamps
    end
  end
end
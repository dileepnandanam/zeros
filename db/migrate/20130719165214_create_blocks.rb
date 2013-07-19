class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.integer :x
      t.integer :y
      t.boolean :n
      t.boolean :e
      t.boolean :w
      t.boolean :s
      t.integer :owner_id

      t.timestamps
    end
  end
end

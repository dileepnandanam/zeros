class AddAvatharToUser < ActiveRecord::Migration
  def change
    add_column :users, :avathar, :string
  end
end

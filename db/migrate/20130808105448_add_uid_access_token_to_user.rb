class AddUidAccessTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string
    add_column :users, :access_token, :string
  end
end

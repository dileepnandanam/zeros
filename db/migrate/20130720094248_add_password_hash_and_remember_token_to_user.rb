class AddPasswordHashAndRememberTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :password_hash, :string
    add_column :users, :password_salt, :string
    add_column :users, :remember_token, :string
  end
end

class AddIndexToUsersEmail < ActiveRecord::Migration[5.2]
  def change
  	#add index to email column of users table
  	#avoids full table scan when user is logging in (matching email in DB)
  	add_index :users, :email, unique: true
  end
end

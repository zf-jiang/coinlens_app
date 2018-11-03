class CreateUsers < ActiveRecord::Migration[5.2]
  def change					#CREATE TABLE 
    create_table :users do |t|	#users(	id integer,
      t.string :name			#  		name varchar(255),
      t.string :email			#  		email varchar(255),
      							#  		created_at datetime,
      t.timestamps				#  		updated_at datetime,
    end							#  		primary key(id) );
  end
end

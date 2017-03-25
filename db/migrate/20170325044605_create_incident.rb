class CreateIncident < ActiveRecord::Migration
  def up
  	create_table :incidents do |t|
  		t.date :incident_date
  		t.string :state
  		t.string :city_or_county
  		t.text :address
  		t.integer :num_killed
  		t.integer :num_injured
  		t.string :url

      t.timestamps null: false
  	end
  	add_index :incidents, [:incident_date, :address, :url], :unique => true
  end

  def down
  	drop_table :incidents
  end
end

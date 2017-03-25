class Incident < ActiveRecord::Base
	validates :incident_date, :state, :city_or_county, :address, :num_killed, :num_injured, :url, presence: true
end
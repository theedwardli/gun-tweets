require './application'
require 'sinatra/activerecord/rake'
require './sinatra/incident_helpers'

task :update_tweets do 
	include Sinatra::IncidentHelpers

	incidents = get_incidents
	insert_and_tweet_incidents(incidents)
end
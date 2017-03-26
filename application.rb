require 'haml'
require 'sinatra'
require 'sinatra/activerecord'

require './config/environments'
require './models/incident'
require './sinatra/incident_helpers'

class Application < Sinatra::Base
  helpers Sinatra::IncidentHelpers

  get "/" do
    @incidents = Incident.order(updated_at: :desc).where(updated_at: (Time.now - 1.hour)..Time.now)
    haml :index
  end

  Incident.order(updated_at: :desc).where(updated_at: (Time.now - 1.hour)..Time.now)
end

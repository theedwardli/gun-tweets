require 'nokogiri'

class Application < Sinatra::Base
  INCIDENTS_URL = 'http://www.gunviolencearchive.org/last-72-hours'
  BASE_URL = 'http://www.gunviolencearchive.org'

  get "/" do
    "Hello World"
  end

  helpers do
    # get last 25 shootings from the archive
    def get_incidents
      page = Nokogiri::HTML(open(INCIDENTS_URL))
      rows = page.css('table').css('tr').to_a.drop(1).map do |row|
        cols = row.css('td').to_a.reduce([]) do |acc, col|
          if col.at_css('a')
            incident_link = col.css('a')[0]['href']
            acc.push(BASE_URL.concat(incident_link))
          else
            acc.push(col.text)
          end
        end
      end
    end
  end
end

require 'open-uri'
require 'nokogiri'
require 'sinatra/base'
require 'twitter'

module Sinatra
	module IncidentHelpers
    INCIDENTS_URL = 'http://www.gunviolencearchive.org/last-72-hours'
    BASE_URL = 'http://www.gunviolencearchive.org'
    IMAGE_SIZE = '640x640'

  	##
    # Gets the last 25 shootings from the Archive
    # 
    # @return an array of incidents
    ##
    def get_incidents
      page = Nokogiri::HTML(open(INCIDENTS_URL))
      rows = page.css('table').css('tr').to_a.drop(1).map do |row|
        cols = row.css('td').to_a.reduce([]) do |acc, col|
          if col.at_css('li')
            incident_link = col.css('li').css('a')[0]['href']
            acc.push(BASE_URL + incident_link)
          else
            acc.push(col.text)
          end
        end
      end
    end

    ##
    # Inserts new incidents into the database and tweets them
    # @param incidents - an array of incidents
    #
    # @return the twitter statuses that were tweeted
    ##
    def insert_and_tweet_incidents incidents
      client = get_twitter_client
      statuses = []

      incidents.each do |incident|
        incident_date = incident[0]
        state = incident[1]
        city_or_county = incident[2]
        address = incident[3]
        num_killed = incident[4].to_i
        num_injured = incident[5].to_i
        url = incident[6]

        begin
          Incident.create!(
            incident_date: incident_date,
            state: state,
            city_or_county: city_or_county,
            address: address,
            num_killed: num_killed,
            num_injured: num_injured,
            url: url
          )

          status = build_status(city_or_county, state, num_killed, num_injured, url)
          file_name = get_street_view(url)
          file_name.nil? ? client.update(status) : client.update_with_media(status, File.new(file_name))

          statuses << status
        rescue ActiveRecord::RecordNotUnique
          puts "We've seen this incident before: #{url}"
        end
      end

      if Incident.count >= 50
        Incident.order(:updated_at).limit(25).destroy_all
      end

      statuses
    end

    ##
    # Creates a Twitter client
    #
    # @return the Twitter client
    ##
    def get_twitter_client
      Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_C_KEY']
        config.consumer_secret     = ENV['TWITTER_C_SECRET']
        config.access_token        = ENV['TWITTER_TOKEN']
        config.access_token_secret = ENV['TWITTER_TOKEN_SECRET']
      end
    end

    ##
    # Uses incident data to prepare a status for publication
    # @param city_or_county - the city or county where the shooting happened
    # @param state - the state where the shooting happened
    # @param num_killed - the number of people killed
    # @param num_injured - the number of people injured
    # @param url - a link to the full incident report
    #
    # @return the status
    ##
    def build_status city_or_county, state, num_killed, num_injured, url
      status = "#{city_or_county}, #{state}: "

      if num_killed.zero? && num_injured.zero?
        status.concat('no one was hurt. ')
      elsif num_killed.zero?
        status.concat("#{num_injured} ")
              .concat('person'.pluralize(num_injured))
              .concat(' injured. ')
      elsif num_injured.zero?
        status.concat("#{num_killed} ")
              .concat('person'.pluralize(num_killed))
              .concat(' killed. ')
      else
        status.concat("#{num_killed} ")
              .concat('person'.pluralize(num_killed))
              .concat(' killed and ')
              .concat("#{num_injured} ")
              .concat('person'.pluralize(num_injured))
              .concat(' injured. ')
      end

      status.concat("Full report: #{url}")
    end

    ##
    # Uses the Google Street View API to get an image of the incident location
    # @param incident_url - a link to the full incident report
    #
    # @return the name of the image file
    ##
    def get_street_view incident_url
      incident_page = Nokogiri::HTML(open(incident_url))
      geo_string = incident_page.css('span').to_a
                                .select { |span| span.text.include?('Geolocation:') }
                                .map { |span| span.text }
                                .first
      unless geo_string.nil?
        geo_string.slice!('Geolocation:')
        geo_string.strip!
        lat_lng_array = geo_string.split(',').map { |coord| coord.strip }
        lat = lat_lng_array.first
        lng = lat_lng_array.last
        incident_num = incident_url.split('/').last

        File.open("/tmp/#{incident_num}.jpg", 'w+') do |f|
          img = open('https://maps.googleapis.com/maps/api/streetview?'
                        .concat("size=#{IMAGE_SIZE}")
                        .concat("&location=#{lat},#{lng}")
                        .concat('&fov=90')
                        .concat('&heading=235')
                        .concat('&pitch=10')
                        .concat("&key=#{ENV['MAP_KEY']}"))
          f.write img.read
        end

        "/tmp/#{incident_num}.jpg"
      end
    end
	end

	helpers IncidentHelpers
end
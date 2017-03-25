require 'rubygems'
require 'bundler'
Bundler.require

if Sinatra::Base.development? 
	require 'dotenv'
	Dotenv.load
end

$stdout.sync = true

require './application'
run Application

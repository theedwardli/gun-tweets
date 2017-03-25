require 'rubygems'
require 'bundler'
Bundler.require

require 'dotenv'
Dotenv.load

require './application'
run Application

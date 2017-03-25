require 'rubygems'
require 'bundler'
Bundler.require

require 'dotenv'
Dotenv.load

$stdout.sync = true

require './application'
run Application

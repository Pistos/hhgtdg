# This file contains your application, it requires dependencies and necessary
# parts of the application.
#
# It will be required from either `config.ru` or `start.rb`

require 'rubygems'
require 'ramaze'
require 'digest/sha1'
require 'cgi'
require 'json'
require 'open-uri'
require 'nokogiri'

# Make sure that Ramaze knows where you are
Ramaze.options.roots = [ __DIR__ ]

require 'config'

PlanetInfo = Struct.new(
  :name, :society, :population, :tax_rate, :tariff_rate,
  :steel, :unobtainium, :food, :antimatter, :consumer_goods, :hydrocarbon, :krellmetal,
  :page
)

# Initialize controllers and models
# require __DIR__( 'model/init' )
require __DIR__( 'controller/init' )

File.open( 'ramaze.pid', 'w' ) do |f|
  f.puts Process.pid
end

Ramaze::Log.loggers = [
  Logger.new( "#{__DIR__}/log/ramaze.log", 'daily' ),
]

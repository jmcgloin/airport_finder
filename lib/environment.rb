require 'pry'
require 'nokogiri'
require 'open-uri'

require_relative "./airport_finder/version"

module AirportFinder
  class Error < StandardError; end
  # Your code goes here...
end

require_relative "./cli"
require_relative "./search"
require_relative "./scraper"
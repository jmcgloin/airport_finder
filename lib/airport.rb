class Airport

	@@all = []

	attr_accessor :identifier, :name

	def initialize(identifier, name, details)
		@identifier = identifier
		@name = name
		@details = details
	end

	def self.all
		@@all
	end

	def self.find(identifier)
		self.all.detect{ |airport| airport.identifier == identifier }
	end

	def self.find_or_create(identifier, url)
		ap = (self.all.detect{ |airport| airport.identifier == identifier } || self.create(url))
		# TODO scrape the airport details and add them
		# TODO add the 
	end

	def self.create(url)
		Scraper.new.scrape_airport_info(url)
		# TODO scrape using the url and create a new aiport object
	end

end
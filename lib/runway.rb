class Runway

	@@all = []

	def initialize(name, length, width, airport)
		@name = name
		@length = length
		@width = width
		@airport = airport
	end

	def self.create(name, length, width, airport)
		#take in the runway table and parse the info for display
	end

	def self.find(name, length, width, airport)
		self.all.detect{ |rway| rway.name == name && rway.airport == airport }
	end

	def self.find_or_create(name, length, width, airport)
		self.find(name, length, width, airport) || self.create(name, length, width, airport)
	end

end
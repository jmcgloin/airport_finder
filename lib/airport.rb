class Airport

	@@all = []

	def initialize(identifier, runways, fsbos, services, coms, operations, owner_manager)
		=begin
			identifier is a string
			runways is an array of objects
			fsbos is an array of objects
			services is a hash
			coms is a hash
			operations  is a hash
			owner_manager is a hash
		=end



	end

	def self.all
		@@all
	end

	def self.find(identifier)
		self.all.detect{ |airport| airport.identifier == identifier }
	end

	def create_from_scrape(airport_data) #maybe change data when you get a better idea of what the data looks like
		
	end

end
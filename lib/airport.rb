class Airport

	@@all = []

	def initialize(identifier, name)# (identifier, runways, fsbos, services, coms, operations, owner_manager)
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

	def self.find_or_create(identifier, name = nil)
		self.find(identifier) || Airport.new(identifier, name)
	end

	def add_airport_details(details_hash)
			self.details ||= details_hash
	end

end
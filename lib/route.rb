class Route

	@@all = []

	attr_accessor :departure :arrival :distance :initial_bearing :final_bearing

	def initialize(departure, arrival)

		@departure = departure
		@arrival = arrival

	end

	def self.create(departure, arrival)
		self.new(departure, arrival)
	end

	def self.find(departure, arrival)
		self.all.detect{ |route| route.departure == departure && route.arrival == arrival }
	end

	def self.find_or_create(departure, arrival)
		self.find(departure, arrival) || self.create(departure, arrival)
	end

	def calculate_distance

	end

	def calculate_bearings

	end

end
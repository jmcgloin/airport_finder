class Runway

	@@all = []

	attr_accessor :name, :dimensions, :airport, :surface

	def initialize(name, airport)
		@name = name
		@airport = airport
	end

	def self.create(name, airport)
		self.new(name, airport).tap{ |rw| self.all << rw }
	end

	def self.find(name, airport)
		self.all.detect{ |rway| rway.name == name && rway.airport == airport }
	end

	def self.find_or_create(name, airport)
		self.find(name, airport) || self.create(name, airport)
	end

	def self.create_runway_from_data(runway_names, runway_data, airport)

		runway_counter = 0
		runway_data.children.each.with_index do |child, i|
			if child.children.count > 0
				case child.children[0].text.gsub(/\u00a0/, '').strip
				when "Dimensions:"
					rw = self.find_or_create(runway_names[runway_counter].text, airport)
					rw.dimensions = child.children[1].text.gsub(/\u00a0/, '').strip
				when "Surface:"
					rw = self.find_or_create(runway_names[runway_counter].text, airport)
					rw.surface = child.children[1].text.gsub(/\u00a0/, '').strip
					rw.add_to_airport(airport)
					runway_counter += 1
				end
			end
		end

	end

	def add_to_airport(airport)
		airport.runways << self
	end

	def self.all
		@@all
	end

end
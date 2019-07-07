class Runway

	@@all = []

	attr_accessor :name, :dimensions, :airport, :surface

	def initialize(name, dimensions, airport)
		@name = name
		@dimensions = dimensions
		@airport = airport
	end

	def self.create(name, dimensions, airport)
		self.new(name, dimensions, airport)
	end

	def self.find(name, airport)
		self.all.detect{ |rway| rway.name == name && rway.airport == airport }
	end

	def self.find_or_create(name, dimensions, airport)
		self.find(name, airport) || self.create(name, dimensions, airport)
	end

	def self.create_runway_from_data(runway_names, runway_data, airport)
		runway_dimensions = []
		runway_surfaces = []
		runway_data.children.each do |child|
			# binding.pry
			if child.children.count > 0
				case child.children[0].text.gsub(/\u00a0/, '').strip
				when "Dimensions:"
					runway_dimensions << child.children[1].text.gsub(/\u00a0/, '').strip
				when "Surface:"
					runway_surfaces << child.children[1].text.gsub(/\u00a0/, '').strip
				end
			end
		end
		runway_names.each.with_index do |name, i|
			rw = self.find_or_create(name.text, runway_dimensions[i], airport)
			rw.surface = runway_surfaces[i]
			# binding.pry
			rw.add_to_airport(airport)
		end
	end

	def add_to_airport(airport)
		airport.runways << self
	end

	def self.all
		@@all
	end

end
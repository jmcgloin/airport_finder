class Search

	@@all = []

	attr_accessor :results, :place, :radius

	def initialize(place, radius)

		@place = place
		@radius = radius

	end

	def self.all
		@@all
	end

	def self.find_or_create(place, radius)
		#look for a past search
		(find(place, radius) || create_new_search(place, radius)).results
	end

	def self.create_new_search(place, radius)
		binding.pry
		Search.new(place, radius).tap do |new_search|
			new_search.results = Scraper.new.scrape_search_results(place, radius)
			self.all << new_search
		end
	end
	def self.find(place, radius)
		self.all.detect{|search| search.place == place && search.radius == radius}
	end

end
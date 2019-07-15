class Search

	@@all = []

	attr_accessor :results, :place, :radius

	def initialize(place)

		@place = place
		@radius = 200

	end

	def self.all
		@@all
	end

	def self.find_or_create(place)
		#look for a past search
		(find(place) || create_new_search(place)).results
	end

	def self.create_new_search(place)
		Search.new(place).tap do |new_search|
			new_search.results = Scraper.new.scrape_search_results(place, new_search.radius)
			self.all << new_search
		end
	end
	def self.find(place)
		self.all.detect{|search| search.place == place}
	end

end
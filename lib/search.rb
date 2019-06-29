class Search

	@@all = []

	attr_accessor :results

	def initialize(place, radius)

		@place = place
		@radius = radius

	end

	def self.all
		@@all
	end

	def self.find_or_create(place, radius)
		#look for a past search
		past_search = self.all.detect{ |search| search.place == place && search.radius == radius }
		past_search ? past_search.results : create_new_search(place, radius).results
	end

	def self.create_new_search(place, radius)
		puts "creating new"
		new_search = Search.new(place, radius)
		new_search.results = [%w(1q1 airport1 1.1), %w(2w2 airport2 2.2), %w(3e3 airport3 3.3)] # Scraper.scrape_search_results(place, radius) TODO wire this up
		self.all << new_search
		new_search
	end

end
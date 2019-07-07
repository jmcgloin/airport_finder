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
		#look for a past search MAKE SURE TO CATCH  REDIRECT WHEN INVALID INPUT
		past_search = self.all.detect{ |search| search.place == place && search.radius == radius }
		past_search ? past_search.results : create_new_search(place, radius).results
	end

	def self.create_new_search(place, radius)
		new_search = Search.new(place, radius)
		new_search.results = Scraper.new.scrape_search_results(place, radius) #TODO wire this up
		self.all << new_search
		new_search
	end

end
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
		past_search || create_new_search(place, radius)
	end

	def create_new_search(place, radius)
		new_search = Search.new(place, radius)
		new_search.results = Scraper.scrape_search_results(place, radius) # 
		self.all << new_search
		new_search
	end

		# airport_menu([])
		# airport_menu(%w(a1, a2, a3, a4, a5))

end
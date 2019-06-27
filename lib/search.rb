class Search

	@@all = []

	def initialize(place, radius, )

		@place = place
		@radius = radius

	end

	def self.all
		@@all
	end

	def self.find_or_create(place, radius)

		#look for a past search
		past_search = self.all.detect{ |search| search.place == place && search.radius == radius }

		#if there is a past search tha meets the criteria, return it
		#if not, new search, call scraper, populate search results, and save to all
		past_search || Search.new(place, radius).tap{ |new_search|  self.class.all << new_search }

	end

end
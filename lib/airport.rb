class Airport

	@@all = []

	attr_accessor :identifier, :name, :details

	def initialize(identifier, name)
		@identifier = identifier
		@name = name
		@details = {}
	end

	def self.all
		@@all
	end

	def self.find(identifier)
		self.all.detect{ |airport| airport.identifier == identifier }
	end

	def self.find_or_create(identifier, name, url)
		(self.all.detect{ |airport| airport.identifier == identifier } || self.create(identifier, name, url))
	end

	def self.create(identifier, name, url)
		
		details_array = Scraper.new.scrape_airport_info(url)
		headings = details_array[0]
		subheadings = details_array[1]
		content_table = details_array[2]
		runways_table = details_array[3]

		ap = Airport.new(identifier, name)

		headings.children.each{ |child| ap.details[child.text.to_sym] = {} }


		binding.pry
		# [headings, subheadings, content_table, runways_table]
		# TODO create the runways and associate with the airport,
		# populate details hash from the headings and content_table
		# probably do most of it by iterating throught the  children of the details and adding them
		# to the appropriate hashes with the needed formating for display
	end

	def make_details_hash(details)

	end

end

=begin
samples

headings.text (with index)
0: Location
1: Airport Operations
2: Airport Communications
3: Nearby radio navigation aids
4: Airport Services
5: Runway Information
6: Airport Operational Statistics
7: Additional Remarks
8: Instrument Procedures
9: Other Pages about Norman Y Mineta San Jose International Airport


content_table only has children, no grandchildren
content_table[0].children.each{ |child| puts child.text }

FAA Identifier: SJC

Lat/Long: 37-21-46.7810N / 121-55-43.0340W37-21.779683N / 121-55.717233W37.3629947 / -121.9286206(estimated)

Elevation: 62.2 ft. / 19.0 m (surveyed)

Variation: 13E (2020)

From city: 2 miles NW of SAN JOSE, CA

Time zone: UTC -7 (UTC -8 during Standard Time)

Zip code: 95110

the blank lines are \n that can be  stripped and the  filtered with != ""



=end
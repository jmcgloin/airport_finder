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
		
		ap = Airport.new(identifier, name)

		details_array = Scraper.new.scrape_airport_info(url)
		ap.make_details_hash(details_array)

	end

	def make_details_hash(details_array)

		headings = details_array[0]
		subheadings = details_array[1]
		content_table = details_array[2]
		runways_table = details_array[3]
		more_info =  details_array[4]

		section_heading, section_content = "", []

		# binding.pry

		headings.children.each{ |child| self.details[child.text.to_sym] = {} }
		self.details.delete(:"Instrument Procedures")

		j = 0
		for i in (0..details.keys.count - 1) do 
			if details.keys[i] == :"Runway Information"
				#do something with runways__table
			elsif details.keys[i].to_s.include? "Other Pages"
				self.details.delete(details.keys[i])
				# binding.pry
			else

				filtered_content = content_table[j].children.select{ |child| child.text.strip != "" }

				filtered_content.each do |subsection|
					# binding.pry if !subsection.children[0]
					section_heading = subsection.children[0].children
					section_content = subsection.children[1].children.map do |el|
						el.text.gsub(/\u00a0/, '')
					end.select{ |et| et.strip != "" }
					details[details.keys[i]][section_heading.text] = section_content
					binding.pry
				end
				j += 1
			end
		end

		binding.pry

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
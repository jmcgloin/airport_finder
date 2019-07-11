class Airport

	@@all = []

	attr_accessor :identifier, :name, :details, :runways

	def initialize(identifier, name)
		@identifier = identifier
		@name = name
		@details = {}
		@runways = []
	end

	def self.all
		@@all
	end

	def self.find(identifier)
		self.all.detect{ |airport| airport.identifier == identifier }
	end

	def self.find_or_create(identifier, name, url)
		self.find(identifier) || self.create(identifier, name, url)
	end

	def self.create(identifier, name, url)
		details_array = Scraper.new.scrape_airport_info(url)
		Airport.new(identifier, name).tap{ |airport| airport.make_details_hash(details_array) }
	end

	def create_runway(runway_names, runways_table)
		Runway.create_runway_from_data(runway_names, runways_table, self)
	end

	def create_details_keys(headings)
		headings.children.each do |child|
			if !(['Instrument Procedures', 'Runway Information'].include?(child.text) || child.text.include?("Other Pages"))
				self.details[child.text.to_sym] = {}
			end
		end
	end

	def make_details_hash(details_array)
################### HOW TO REFACTOR THIS??????? ############################
# one method that does the logical checking and calls other method to do the iterating/assigning/returning
		headings = details_array[0]
		content_table = details_array[2]
		more_info =  details_array[4]

		create_runway(details_array[1], details_array[3])

		section_heading, section_content = "", []

		create_details_keys(headings)

		j = 0
		for i in (0..self.details.keys.count - 1) do 
			
			filtered_content = content_table[j].children.select{ |child| child.text.strip != "" }
			filtered_content.each.with_index do |subsection, k|
				if i != 3 && i != 5
					section_heading = subsection.children[0].text
					section_content = subsection.children[1].children.map do |el|
						el.text.gsub(/\u00a0/, '')
					end.select{ |et| et.strip != "" }
				elsif i == 3
					if k == 0
						sec_split = subsection.text.split(/\u00a0{2}/)
						section_heading = "   "
						section_content = "#{sec_split[0]} |#{sec_split[1]}               |#{sec_split[2]}   |#{sec_split[3]}"
					else
						sec_split = subsection.children.map do |el|
							el.text.gsub(/\u00a0/, '').strip
						end.select{ |el| el != "" }
						section_heading = k.to_s + ":" + (" " * (3 - k.to_s.chars.count))
						section_content = "#{sec_split[0]}#{" " * (20 - sec_split[0].chars.count)}|#{sec_split[1]}#{" " * (23 - sec_split[1].chars.count)}|#{sec_split[2]}|#{sec_split[3]}"
					end
				elsif i == 5
					trs = subsection.css("tr")
					section_heading = []
					section_content = []
					trs.each do |tr|
						section_heading << tr.children[0].text if tr.children[0]
						if tr.children[2]
							section_content << tr.children[2].text
						elsif tr.children[1]
							section_content << tr.children[1].text
						else
							section_content << ""
						end
					end
				end
				if i != 5
					details[details.keys[i]][section_heading] = section_content
				else
					section_heading.each.with_index{ |sh, m| details[details.keys[i]][sh] = section_content[m]}
				end

			end
			j += 1
			
		end
	end
end
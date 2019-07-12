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

	def create_runway(runway_names, runways_info)
		Runway.create_runway_from_data(runway_names, runways_info, self)
	end

	def create_details_keys(headings)
		headings.children.each do |child|
			if !(['Instrument Procedures', 'Runway Information'].include?(child.text) || child.text.include?("Other Pages"))
				self.details[child.text.to_sym] = {}
			end
		end
	end

	def ops_stats_details(subsection)

		trs = subsection.css("tr")
		trs.each do |tr|
			if tr.children[0]
				if tr.children[2]
					details[details.keys[5]][tr.children[0].text] = tr.children[2].text
				elsif tr.children[1]
					details[details.keys[5]][tr.children[0].text] = tr.children[1].text if tr.children[1]
				else
					details[details.keys[5]][tr.children[0].text] = ""
				end
			end
		end

	end

	def make_remarks(remarks)

		remarks.select{ |remark| remark.text.strip != "" }.each.with_index(1) do |remark, i|
			details[details.keys[6]][i.to_s] = remark.text
		end

	end

	def make_navaids(subsection, k)

		if k == 0
			sec_split = subsection.text.split(/\u00a0{2}/)
			["   "," #{sec_split[0]} | #{sec_split[1]} #{sec_split[2]}   | #{sec_split[3]}\n #{'-' * 59}"]
		else
			sec_split = subsection.children.map do |el|
				el.text.gsub(/\u00a0/, '').strip
			end.select{ |el| el != "" }
			[k.to_s + ":" + (" " * (3 - k.to_s.chars.count)),
				" #{sec_split[0]}#{" " * (20 - sec_split[0].chars.count)}|\
				 #{sec_split[1]}#{" " * (23 - sec_split[1].chars.count)}|\
				 #{sec_split[2]}#{" " * (7 - sec_split[2].chars.count)}| #{sec_split[3]}"]
		end
	end

	def make_details_hash(details_array)
		headings = details_array[0]
		content = details_array[2]
		create_runway(details_array[1], details_array[3])
		section_heading, section_content = "", []
		create_details_keys(headings)
		make_remarks(content[6].children)

		# binding.pry ## look at content.text... 
		for i in (0..self.details.keys.count - 1) do 
			
			filtered_content = content[i].children.select{ |child| child.text.strip != "" }
			filtered_content.each.with_index do |subsection, k|
				if ![3,5,6].include?(i)
					## main details
					section_heading = subsection.children[0].text
					section_content = subsection.children[1].children.map do |el|
						el.text.gsub(/\u00a0/, '')
					end.select{ |et| et.strip != "" }
				elsif i == 3
					section_heading, section_content = make_navaids(subsection, k)
				elsif i == 5
					ops_stats_details(subsection)
				end
				if ![5,6].include?(i)
					# creates the hash for details except operational statistics
					details[details.keys[i]][section_heading] = section_content
				end

			end
		end
	end
end
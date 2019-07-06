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
		ap

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
				#do something with runways_table
				#if runways_table.children.each child.children.count == 2 then its common infor for a runway
				#if runways_table.children.each child.children.count == 4 then its info for each heading
				#if runways_table.children.each child.children.count == 0 twice in a row, its a new runway
				subheadings.each{ |sh| details[:"Runway Information"][sh] = [] }
				
				runways_table.children.each do |child|

				#50 char width
					gchilds = child.children
					case gchilds.count
					when 4
						#if child.children[0] == "" then its a new heading
						#details[:"Runway Information"][subheadings[j]] << 
						puts 4
					when 2
						spaces = 12 - gchilds[0].chars.count
						details[:"Runway Information"][subheadings[j]] << 
				end
				details[:"Runway Information"][subheadings[j]][]
				binding.pry
			elsif details.keys[i].to_s.include? "Other Pages"
				self.details.delete(details.keys[i])
				# binding.pry
			else

				filtered_content = content_table[j].children.select{ |child| child.text.strip != "" }

				filtered_content.each.with_index do |subsection, k|
					# binding.pry if !subsection.children[0]
					if i != 3
						section_heading = subsection.children[0].text
						section_content = subsection.children[1].children.map do |el|
							el.text.gsub(/\u00a0/, '')
						end.select{ |et| et.strip != "" }
					else
						if k == 0
							sec_split = subsection.text.split(/\s/)
							section_heading = " " * 3
							section_content = "#{sec_split[0]}|#{sec_split[1]}     |#{sec_split[2]}   |#{sec_split[3]}"
						else
							sec_split = subsection.children.map{ |el| el.text.gsub(/\u00a0/, '').strip }.select{ |el| el != "" }
							section_heading = k.to_s + ":" + (" " * (3 - k.to_s.chars.count))
							section_content = "#{sec_split[0]}       |#{sec_split[1]}|#{sec_split[2]}|#{sec_split[3]}"
						end
					end
					details[details.keys[i]][section_heading] = section_content
					# binding.pry
				end
				j += 1
			end
		end

		# binding.pry

	end



end

=begin
pry(#<Airport>)> content_table[3].text
=> "\nVOR radial/distance  VOR name  Freq  Var\nDJBr132/22.5DRYER VOR/DME113.6005W\nACOr277/25.5AKRON VOR/DME114.4004W\nBSVr331/27.9BRIGGS VOR/DME112.4004W\nCXRr235/35.6CHARDON VOR/DME112.7005W\n"
[5] pry(#<Airport>)> content_table[3].children[0].text
=> "\n"
[6] pry(#<Airport>)> content_table[3].children[1].text
=> "VOR radial/distance  VOR name  Freq  Var"
[7] pry(#<Airport>)> content_table[3].children[2].text
=> "\n"
[8] pry(#<Airport>)> content_table[3].children[3].text
=> "DJBr132/22.5DRYER VOR/DME113.6005W"
[9] pry(#<Airport>)> content_table[3].children[3].children[0].text
=> "DJBr132/22.5"
[10] pry(#<Airport>)> 

VOR radial/distance|VOR name     |Freq   |Var
DJBr132/22.5       |DRYER VOR/DME|113.600|5W

=end
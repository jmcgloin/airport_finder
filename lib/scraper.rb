class Scraper


	def scrape_search_results(place, radius)
		search_url = "http://www.airnav.com/cgi-bin/airport-search?place=#{place}&airportid=&lat=&NS=N&lon=&EW=W&fieldtypes=a&use=u&iap=0&length=&fuel=0&mindistance=0&maxdistance=#{radius}&distanceunits=nm"
		data = get_data(search_url)
		return_data = []
		if data.css("body h1").text == "Airport Search Results"
			rows = data.css("tr")
			rows.each do |row|
				if !row.css("a[href]").empty? && row.css("a")[0]["href"].include?("/airport/")
					row.css("td").map{ |td| td.text }.tap do |td_array|
						td_array << row.css("a")[0]["href"]
						return_data << td_array
					end
				end
			end
			return_data
		else
			[]
		end


	end # scrape_search_results


=begin 

TDOD there looks to be one a for each section.  sort out the sections and  details
	based on the organization of the a tags

=end


	def scrape_airport_info(url)
		details = {}
		search_url = "http://www.airnav.com" + url
		data = get_data(search_url)
		main_table = data.css("body > table")[4]
		headings = main_table.css("h3")
		binding.pry
		content_table = main_table.css("table")
		content_table.each.with_index do |tr,  i|
			details[headings[i + 1].text.to_sym] = {}
			section = details[headings[i + 1].text.to_sym]
			tds = tr.css("td")
			for j in (0..tds.length - 1).step(2) do
				values = tds[j + 1].children.map{ |child| child.text }.select{ |child| child != "" }
				section[tds[j].text.to_sym] = values
				binding.pry if values.include? "95110"
			end
			binding.pry
		end
		binding.pry
	end

	def get_data(url)
		Nokogiri::HTML(open(url))
	end

end # Scraper

# content_table.each.with_index{ |part,i| puts i,part.css("td").text }

=begin
http://www.airnav.com/cgi-bin/airport-search?place=#{place}&airportid=&lat=&NS=N&lon=&EW=W&fieldtypes=a&use=u&iap=0&length=&fuel=0&mindistance=0&maxdistance=#{radius}&distanceunits=nm

=end
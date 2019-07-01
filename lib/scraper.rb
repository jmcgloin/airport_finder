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

	a + h3 + table  works for most of the  content
	runways are under a + h3 + h4 + table and the h4 is also needed
	aiport ownership doesn't have an a


	details = doc.css('details').find{|node| node.css('id').text == "5678"}

=end




	def scrape_airport_info(url)
		details = {}
		search_url = "http://www.airnav.com" + url
		data = get_data(search_url)
		headings = data.css("a + h3")
		subheadings = data.css("a + h3 + h4")
		content_table = data.css("a + h3 + table")
		runways_table = data.css("a + h3 + h4 + table")


		#headings has one more entry than content table.  that extra  entry is  due to
		#runway information being in a separate table, runways_table
		#at that index, put the runways_table and subheadings in place
		j = 0
		for i in (0..headings.count - 1) do
			if headings[i].text == "Runway Information"
				j -= 1
				details[headings[i].text.to_sym] = 	
			details[headings[i].text.to_sym] = content_table[i]
		end


		binding.pry

		# main_table = data.css("body > table")[4]
		# headings = main_table.css("h3")
		# binding.pry
		# content_table = main_table.css("table")
		# content_table.each.with_index do |tr,  i|
		# 	details[headings[i + 1].text.to_sym] = {}
		# 	section = details[headings[i + 1].text.to_sym]
		# 	tds = tr.css("td")
		# 	for j in (0..tds.length - 1).step(2) do
		# 		values = tds[j + 1].children.map{ |child| child.text }.select{ |child| child != "" }
		# 		section[tds[j].text.to_sym] = values
		# 		binding.pry if values.include? "95110"
		# 	end
		# 	binding.pry
		# end
		# binding.pry
	end

	def get_data(url)
		Nokogiri::HTML(open(url))
	end

end # Scraper

# content_table.each.with_index{ |part,i| puts i,part.css("td").text }

=begin
http://www.airnav.com/cgi-bin/airport-search?place=#{place}&airportid=&lat=&NS=N&lon=&EW=W&fieldtypes=a&use=u&iap=0&length=&fuel=0&mindistance=0&maxdistance=#{radius}&distanceunits=nm

=end
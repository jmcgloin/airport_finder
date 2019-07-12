class Scraper


	def scrape_search_results(place, radius)
		
		search_url = "http://www.airnav.com/cgi-bin/airport-search?place=#{place}&airportid=&lat=&NS=N&lon=&EW=W&fieldtypes=a&use=u&iap=0&length=&fuel=0&mindistance=0&maxdistance=#{radius}&distanceunits=nm"
		data = get_data(search_url)
		return_data = []
		if data.css("body h1").text == "Airport Search Results"
			rows = data.css("tr")
			rows.each do |row|
				if !row.css("a[href]").empty? && row.css("a")[0]["href"].include?("/airport/")
					row.css("td").map{ |td| td.text.gsub(/\u00a0/, '') }.tap do |td_array|
						td_array << row.css("a")[0]["href"]
						return_data << td_array
					end
				end
			end
			return_data
		else
			[] # return an empty array when the search results page is not returned
		end

	end


	def scrape_airport_info(url)
		
		## look at the names here.  can they be  more meaningful?
		details = {}
		search_url = "http://www.airnav.com" + url
		data = get_data(search_url)
		headings = data.css("a + h3") #these are actually  headings, pretty good name
		runway_subheadings = data.css("h4")
		content = data.css("a + h3 + table") # these tables contain the main bulk of the content excluding the runway info
		runways_info = data.css("h4 + table") # these table contain the runway info

		[headings, runway_subheadings, content, runways_info]

	end # scrape_airport_info

	def get_data(url)
		Nokogiri::HTML(open(url))
	end

end # Scraper

=begin
http://www.airnav.com/cgi-bin/airport-search?place=#{place}&airportid=&lat=&NS=N&lon=&EW=W&fieldtypes=a&use=u&iap=0&length=&fuel=0&mindistance=0&maxdistance=#{radius}&distanceunits=nm

=end
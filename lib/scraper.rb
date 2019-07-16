class Scraper


	def scrape_search_results(place, radius)
		
		search_url = "http://www.airnav.com/cgi-bin/airport-search?place=#{place}&airportid=&lat=&NS=N&lon=&EW=W&fieldtypes=a&use=u&iap=0&length=&fuel=0&mindistance=0&maxdistance=#{radius}&distanceunits=nm"
		data = get_data(search_url)
		if data.css("body h1").text == "Airport Search Results"			
			return_array = data.css("tr").map  do |row|
				if !row.css("a[href]").empty? && row.css("a")[0]["href"].include?("/airport/")
					row.css("td").map{ |td| td.text.gsub(/\u00a0/, '') }.tap do |td_array|
						td_array << row.css("a")[0]["href"]
					end
				end
			end
			return_array
		end
		[]
	end

	def scrape_airport_info(identifier, name, url)
		search_url = "http://www.airnav.com" + url
		data = get_data(search_url)
		Airport.new(identifier, name).tap do |airport|
			airport.make_details_hash([data.css("a + h3"), data.css("h4"), data.css("a + h3 + table"), data.css("h4 + table")])
		end
	end

	def get_data(url)
		Nokogiri::HTML(open(url))
	end

end # Scraper
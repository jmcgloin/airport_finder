class AirportFinder::CLI

	attr_accessor :choice, :location, :matches, :airport, :max_choice

	
	def radius=(radius)
		@radius = 20 if @radius.to_i == 0
		if radius.to_i <= 0
			@radius = 20
		else
			@radius = radius.to_i
		end
		@radius = [@radius, 200].min
	end

	def radius
		@radius
	end

	def welcome

			system "clear"
			puts "\nWelcome to Airport Finder!"
			
			choose_location_prompt

			exit

	end

### Begin locate airport chain

	def choose_location_prompt
		if choice != 'exit'
			puts "\nPlease enter the city and state OR the zip code to search"
			puts  "Example: 'Albuquerque, NM'; Example: '90210'"
			puts "Or type 'exit' to exit."

			gets_and_hand_off(:choose_location_input)
		end
	end

	def choose_location_input
		if choice != 'exit'
			self.location = self.choice
			if self.location == ""
				self.whoops
				choose_location_prompt
			elsif (!self.location.match?(/^\d{5}$/) && !self.location.match?(/^[a-zA-Z]+\s*[a-zA-Z]*\,+\s*[a-zA-Z]{2}$/))
				puts "\nPlease use either a five digit zip code or city name with two letter state abbreviation"
				puts "as in the following examples: 'Albuquerque, NM'; '90210'"
				gets_and_hand_off(:choose_location_input)
			else
				puts "\nThe location is #{self.location}.  Is this ok?"
				puts "Please enter 'y' for yes or 'n' for no."
				print '(y) '
				gets_and_hand_off(:is_this_ok?) ? choose_radius_prompt : choose_location_prompt
			end
		end
	end

	def choose_radius_prompt
		if choice != 'exit'
			puts "\nPlease enter the maximum search radius in nm (integers only)"
			puts "Or press enter to accept the default of 20nm"
			puts "Min radius is 1nm. Max radius is 200nm"
			print '(20)'
			gets_and_hand_off(:choose_radius_input)
		end
	end

	def choose_radius_input
		if choice != 'exit'
			self.radius = self.choice.to_i
			if self.choice.to_i <= 0 || self.choice.to_i > 200
				puts "\nThe search radius must be between 1nm and 200nm"
				puts "The search radius has defaulted to 20nm.  Is this ok?"
			else
				puts "\nThe radius is #{self.radius}.  Is this ok?"
			end
			puts "Please enter 'y' for yes or 'n' for no."
			print '(y) '
			gets_and_hand_off(:is_this_ok?) ? get_matches : choose_radius_prompt
		end
	end

	def get_matches
		self.matches = Search.find_or_create(self.location).compact.select do |match|
			match[3].split(" ")[0].to_f <= self.radius
		end
		matches_input
	end

	def matches_input
		if self.choice != 'exit'
			system "clear"
			self.matches
			if self.matches.length == 0
				puts "\nYour search of #{self.location} with a radius of #{self.radius} did not return any matches."
				puts "Would you like to try again? Enter 'y' for yes or 'n' for no."
				print "(y) "

				gets_and_hand_off

				case self.choice
				when 'y', ''
					self.choice = nil
					choose_location_prompt
				when 'n'
					self.choice = nil
					nil
				when 'exit'
					nil
				else
					self.choice = nil
					self.whoops
					matches_input
				end
			else
				display_matches
			end
		end
	end

	def display_matches
		if choice != 'exit'
			puts "\n\nHere are your matches\n\n"
			puts "#: Identifier | City                                    | Name"
			# 14|
			self.matches.each.with_index(1) do |match, i|
				puts "#{i}:#{' ' * (3 - i.to_s.chars.count)}#{match[0]}#{' ' * 13}".slice(0,14) + '| ' +
				"#{match[1]}#{' ' * 40}".slice(0,40) + '| ' +
				"#{match[2]}#{' ' * 50}".slice(0,50) + "\n"
			end
			select_from_matches_prompt
		end

	end

	def select_from_matches_prompt
		if self.choice != 'exit'
			puts "\nPlease enter the number of the airport."
			gets_and_hand_off(:select_from_matches_input)
		end
	end


	def select_from_matches_input
		if self.choice != 'exit'
			system "clear"
			if self.choice.to_i <= 0 || self.choice.to_i > self.matches.length || self.choice.match(/\D+/)
				self.whoops
				display_matches
			else
				selected_airport = matches[self.choice.to_i - 1]
				self.airport = Airport.find_or_create(selected_airport[0].strip, selected_airport[2].strip, selected_airport[4])
				learn_more_prompt
			end
		end
	end

	def learn_more_prompt
		if self.choice != 'exit'
			self.choice = nil if caller[0].include? "select_from_matches_input"
			self.max_choice = self.airport.details.keys.count + 4
			puts "\n #{self.airport.identifier} - #{self.airport.name}:\n\n"
			self.airport.details.keys.each.with_index(1) do |key, i|
				if self.choice.to_i == i
					puts "#{i.to_s.red}:#{' ' * (3 - i.to_s.chars.count)}#{key}"
				else
					puts "#{i}:#{' ' * (3 - i.to_s.chars.count)}#{key}"
				end
			end
			max_less_three_str = "#{(self.max_choice - 3) == self.choice.to_i ? (self.max_choice - 3).to_s.red : (self.max_choice - 3)}"
			max_less_three_str += ":#{' ' * (3 - (self.max_choice - 3).to_s.chars.count)}Runways"
			max_less_two_str = "#{(self.max_choice - 2) == self.choice.to_i ? (self.max_choice - 2).to_s.red : (self.max_choice - 2)}"
			max_less_two_str += ":#{' ' * (3 - (self.max_choice - 2).to_s.chars.count)}View on chart"
			puts max_less_three_str
			puts max_less_two_str
			puts "#{self.max_choice - 1}:#{' ' * (3 - (self.max_choice - 1).to_s.chars.count)}Choose another aiport from this search"
			puts "#{self.max_choice}:#{' ' * (3 - self.max_choice.to_s.chars.count)}Back to main menu"
			puts "\nEnter the number of the topic you want to know more about."

			gets_and_hand_off(:learn_more_input)
		end
	end

	def learn_more_input
		if self.choice != 'exit'
			if self.choice.to_i == self.max_choice
				print 'Returning to main menu'
				slow_ellipsis
				choose_location_prompt
			elsif (self.choice.to_i == self.max_choice - 1)
				system "clear"
				display_matches
			else
				system "clear"
				case self.choice.to_i
				when (1..self.max_choice - 4)
					display_details
				when (self.max_choice - 3)
					display_runway_info
				when (self.max_choice - 2)
					display_chart
				else
					self.whoops
				end
				learn_more_prompt
			end
		end
	end

	def display_details
		choice_int = self.choice.to_i
		category = self.airport.details.keys[choice_int - 1]
		system "clear"
		puts "\nShowing #{category} for #{self.airport.name}\n\n"
		self.airport.details[category].each_pair.with_index do |(topic, data), i|
			case choice_int
			when 4
				puts "#{data}\n"
			when 6
				puts "#{topic}#{data}"
			when 7
				binding.pry if (3 - topic.chars.count) < 0
				puts "#{topic}:#{" " * ( 3 - topic.chars.count)}#{data}"
			else
				puts "#{topic}#{data.join("\n#{" " * (topic.chars.count)}")}"
			end
		end
	end

	def display_runway_info
		system "clear"
		puts "\n\nShowing runways for #{self.airport.name}\n"
		self.airport.runways.each.with_index(1) do |rw, i|
			puts "\n#{i}: #{rw.name} is #{rw.dimensions} and is made of #{rw.surface}"
		end
	end

	def display_chart
		latlong = airport.details[:Location]["Lat/Long: "][2].split(" / ")
		lat = latlong[0].to_f
		long = latlong[1].to_f
		chart_url = "http://vfrmap.com/?type=vfrc&lat=#{lat}&lon=#{long}&zoom=10"
		print "Opening chart for #{airport.name}"
		slow_ellipsis
		Launchy.open(chart_url)
		sleep(1)
	end

## End locate airport chain

	def gets_and_hand_off(function = false)
		self.choice = gets.strip.downcase
		send(function) if (function && self.choice != "exit")
	end

	def check_for_float(value)
		value.to_i == value.to_f
	end

	def slow_ellipsis
		3.times do
			$stdout.flush
			print " ."
			sleep(0.5)
		end
		system "clear"
	end

	def exit
		puts "\n\n#{[
			"Roger that!",
			"Clear skys!",
			"Don't forget to close your flight plan!",
			"Any landing you can walk away from...",
			"Tie downs, check.  Wheel chocks, check.",
			"Barrel Roll!"
		].shuffle[0]}\n\n\n"
	end

	def is_this_ok?

		if choice != "exit"			
			case choice
			when 'y'
				return true
			when ''
				return true
			when 'n'
				return false
			else
				self.whoops
				return false
			end
		end
	end

	def whoops
		puts "\nWhoops!  I don't understand that.  Let's try again."
	end

end
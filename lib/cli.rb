class AirportFinder::CLI

	attr_accessor :choice, :location, :matches, :airport, :max_choice

	
	def radius=(radius = 20)

		@radius = [radius.to_i, 20].max
		@radius = [@radius, 200].min
	end

	def radius
		@radius
	end

	def initialize

		@place = ""
		@choice = nil
		@matches = []
		@airport = nil

	end

	def welcome

			system "clear" # add this to a few locations to keep the screen clean TODO-TIME
			puts "\nWelcome to Airport Finder!"
			
			main_menu_prompt

	end

	def main_menu_prompt

		while choice != "exit"
			puts "\nWhat would you like to do?"
			puts "Please select from the following choices:"
			puts "1: Locate an airport by city/state or zip code"
			puts "2: Plan a route between two airports"
			puts "Enter the number of your choice or type 'exit' to exit."

			gets_and_hand_off(:main_menu_input)
		end

		exit
	end

	def main_menu_input
		
		if choice != 'exit'
			input, self.choice = self.choice, nil
			case input
			when "1"
				choose_location_prompt # locate_airport
			when "2"
				plan_route
			when "exit"
				self.choice = 'exit'
			else
				self.whoops
			end
		end

	end

### Begin locate airport chain

	def choose_location_prompt
		if choice != 'exit'
			puts "\nPlease enter the city and state OR the zip code to search"
			puts "Example: 'Albuquerque, New Mexico'; Example: '90210'"

			gets_and_hand_off(:choose_location_input)
		end

	end

	def choose_location_input

		if choice != 'exit'
			self.location, self.choice = self.choice, nil
			case self.location
			when ""
				choose_location_prompt
			else
				puts "\nThe location is #{self.location}.  Is this ok?"
				puts "Please enter 'y' for yes or 'n' for no."

				gets_and_hand_off(:is_this_ok?) ? choose_radius_prompt : choose_location_prompt

			end
		end

	end

	def choose_radius_prompt

		if choice != 'exit'
			puts "\nPlease enter the maximum search radius in nm"
			puts "Or press enter to accept the default of 20nm"
			puts "Min radius is 20nm. Max radius is 200nm"

			gets_and_hand_off(:choose_radius_input)
		end

	end

	def choose_radius_input

		if choice != 'exit'
			self.radius, self.choice = self.choice, nil
			case self.radius
			when ""
				choose_location_prompt
			else
				puts "\nThe radius is #{self.radius}.  Is this ok?"
				puts "Please enter 'y' for yes or 'n' for no."

				gets_and_hand_off(:is_this_ok?) ? get_matches : choose_radius_prompt

			end
		end

	end

	def get_matches

		self.matches = Search.find_or_create(self.location, self.radius)
		matches_input

	end

	def matches_input

		if self.choice != 'exit'
			if self.matches.length == 0
				puts "\nYour search of #{self.location} with a radius of #{self.radius} did not return any matches."
				puts "Would you like to try again? Enter 'y' for yes or 'n' for no.(y)"

				gets_and_hand_off

				case self.choice # gets_and_hand_off
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
			puts "Here are your matches\n"
			puts "#: Identifier | City                                    | Name"
			# 14|
			matches.each.with_index(1) do |match, i|
				line = []
				line << ("#{i}: #{match[0]}" + (" " * 13)).slice(0,14) + "| "
				line << (match[1] + (" " * 40)).slice(0,40) + "| "
				line << (match[2] + (" " * 50)).slice(0,50) + "\n"
				puts line.join("")
			end

			select_from_matches_prompt
		end

	end

	def select_from_matches_prompt

		if self.choice != 'exit'
			puts "Please enter the number of the airport."
			gets_and_hand_off(:select_from_matches_input)
		end

	end


	def select_from_matches_input

		if self.choice != 'exit'
			selection, self.choice = self.choice.to_i, nil
			if selection == 0 || selection > self.matches.length
				self.whoops
				select_from_matches_prompt
			else
				selected_airport = matches[selection - 1]
				self.airport = Airport.find_or_create(selected_airport[0].strip, selected_airport[2].strip, selected_airport[4])
				learn_more_prompt
			end
		end

	end

	def learn_more_prompt

		if self.choice != 'exit'
			self.max_choice = self.airport.details.keys.count + 3
			puts "\n #{self.airport.identifier} - #{self.airport.name}:"
			self.airport.details.keys.each.with_index(1){ |key, i| puts "#{i}:#{' ' * (3 - i.to_s.chars.count)}#{key}"}
			puts "#{self.max_choice - 2}:#{' ' * (3 - (self.max_choice - 1).to_s.chars.count)}Runways"
			puts "#{self.max_choice - 1}:#{' ' * (3 - (self.max_choice - 1).to_s.chars.count)}View on chart"
			puts "#{self.max_choice}:#{' ' * (3 - self.max_choice.to_s.chars.count)}Done"
			puts "\nEnter the number of the topic you want to know more about."

			gets_and_hand_off(:learn_more_input)
		end

	end

	def learn_more_input

		if self.choice != 'exit'
			
			case self.choice
			when (1..self.max_choice - 3)
				display_details
			when (self.max_choice - 2)
				display_runway_info
			when (self.max_choice - 1)
				display_chart
			when self.max_choice
				print 'Returning to main menu'
				slow_ellipsis
				main_menu_prompt
			else
				self.whoops
				learn_more_prompt
			end

		end
	end

	def display_details

		category = self.airport.details.keys[self.choice - 1]
		puts "\nShowing #{category}\n"
		self.airport.details[category].each_pair.with_index do |(topic, data), i|
			puts "#{topic}#{data.join("\n#{" " * (topic.chars.count)}")}" if (choice != 4 && choice != 6)
			puts "#{data}\n" if choice == 4
			puts "#{topic}#{data}" if choice == 6
		end
	end

	def display_runway_info
		self.airport.runways.each.with_index(1) do |rw, i|
			puts "\n#{i}: #{rw.name} is #{rw.dimensions} and is made of #{rw.surface}"
		end
	end



# while !choice.to_i.between?(1,max_choice)
	# 		self.whoops
	# 		puts "Enter the number of the topic you want to know more about."
	# 		choice = gets.strip
	# 	end
	# 	while choice.to_i != max_choice
	# 		case choice.to_i
	# 		when (1..max_choice - 3)
	# 			show_details(airport.details, choice.to_i)
	# 		when max_choice - 2
	# 			show_runway_info(airport)
	# 		when max_choice - 1
	# 			show_chart(airport)
	# 		end
	# 		puts "\nWhat else would you like to see?"
	# 		airport.details.keys.each.with_index(1){ |key, i| puts "#{i}:#{' ' * (3 - i.to_s.chars.count)}#{key}"}
	# 		puts "#{max_choice - 2}:#{' ' * (3 - (max_choice - 1).to_s.chars.count)}Runways"
	# 		puts "#{max_choice - 1}:#{' ' * (3 - (max_choice - 1).to_s.chars.count)}View on chart"
	# 		puts "#{max_choice}:#{' ' * (3 - max_choice.to_s.chars.count)}Done"
	# 		puts "\nEnter the number of the topic you want to know more about."
	# 		choice = gets.strip
	# 		while !choice.to_i.between?(1,max_choice)
	# 			self.whoops
	# 			puts "Enter the number of the topic you want to know more about."
	# 			choice = gets.strip
	# 		end
	# 	end
	# 	print "\nReturning to main menu"
	# 	slow_ellipsis



################## refactor this section next ##########################
	# def airport_menu(matches)
################# 		
		# count = matches.length
		# if count == 0
		# 	puts "Your search of #{self.place} with a radius of #{self.radius} did not return any matches."
		# 	puts "Would you like to try again? Enter 'y' for yes or 'n' for no.(y)"

		# 	continue = gets.strip.downcase

		# 	case continue
		# 	when 'y'
		# 		locate_airport
		# 	when 'n'
		# 		nil
		# 	when ''
		# 		locate_airport
		# 	else
		# 		while (continue != "y" && continue != "n") do
		# 			self.whoops
		# 			puts "Would you like to try again? Enter 'y' for yes or 'n' for no.(y)"
		# 			continue = gets.strip.downcase
		# 		end
		# 	end
		# else
		# 	puts "Here are your matches\n"
		# 	puts "#: Identifier | City                                    | Name"
		# 	# 14|
		# 	matches.each.with_index(1) do |match, i|
		# 		line = []
		# 		line << ("#{i}: #{match[0]}" + (" " * 13)).slice(0,14) + "| "
		# 		line << (match[1] + (" " * 40)).slice(0,40) + "| "
		# 		line << (match[2] + (" " * 50)).slice(0,50) + "\n"
		# 		puts line.join("")
		# 	end
		# end
		# airport_select(matches) if continue != "n"
	# end

	# def airport_select(matches)
		# puts "Please enter the number of the airport."
		# choice = gets.strip
		# while choice.to_i == 0 || choice.to_i > matches.length do
		# 	self.whoops # add in a  condition for input of 'exit'
		# 	choice = gets.strip
		# end
		# puts matches[choice.to_i - 1][4] # TODO find or create airport
		# selection = matches[choice.to_i - 1]
		# airport = Airport.find_or_create(selection[0].strip, selection[2].strip, selection[4])
		# learn_more(airport)
	# end

	# def learn_more(airport)
	# 	# max_choice = airport.details.keys.count + 3
	# 	# puts "\n #{airport.identifier} - #{airport.name}:"
	# 	# airport.details.keys.each.with_index(1){ |key, i| puts "#{i}:#{' ' * (3 - i.to_s.chars.count)}#{key}"}
	# 	# puts "#{max_choice - 2}:#{' ' * (3 - (max_choice - 1).to_s.chars.count)}Runways"
	# 	# puts "#{max_choice - 1}:#{' ' * (3 - (max_choice - 1).to_s.chars.count)}View on chart"
	# 	# puts "#{max_choice}:#{' ' * (3 - max_choice.to_s.chars.count)}Done"
	# 	# puts "\nWould you like to learn more about this airport?"
	# 	# puts "Enter the number of the topic you want to know more about."
	# 	# choice = gets.strip
	# 	while !choice.to_i.between?(1,max_choice)
	# 		self.whoops
	# 		puts "Enter the number of the topic you want to know more about."
	# 		choice = gets.strip
	# 	end
	# 	while choice.to_i != max_choice
	# 		case choice.to_i
	# 		when (1..max_choice - 3)
	# 			show_details(airport.details, choice.to_i)
	# 		when max_choice - 2
	# 			show_runway_info(airport)
	# 		when max_choice - 1
	# 			show_chart(airport)
	# 		end
	# 		puts "\nWhat else would you like to see?"
	# 		airport.details.keys.each.with_index(1){ |key, i| puts "#{i}:#{' ' * (3 - i.to_s.chars.count)}#{key}"}
	# 		puts "#{max_choice - 2}:#{' ' * (3 - (max_choice - 1).to_s.chars.count)}Runways"
	# 		puts "#{max_choice - 1}:#{' ' * (3 - (max_choice - 1).to_s.chars.count)}View on chart"
	# 		puts "#{max_choice}:#{' ' * (3 - max_choice.to_s.chars.count)}Done"
	# 		puts "\nEnter the number of the topic you want to know more about."
	# 		choice = gets.strip
	# 		while !choice.to_i.between?(1,max_choice)
	# 			self.whoops
	# 			puts "Enter the number of the topic you want to know more about."
	# 			choice = gets.strip
	# 		end
	# 	end
	# 	print "\nReturning to main menu"
	# 	slow_ellipsis

	# end

	# def show_details(details, choice)
	# 	category = details.keys[choice - 1]
	# 	puts "\nShowing #{category}\n"
	# 	details[category].each_pair.with_index do |(topic, data), i|
	# 		puts "#{topic}#{data.join("\n#{" " * (topic.chars.count)}")}" if (choice != 4 && choice != 6)
	# 		puts "#{data}\n" if choice == 4
	# 		if choice == 6
	# 			# binding.pry
	# 			puts "#{topic}#{data}"
	# 		end
	# 	end

	# end

	def show_chart(airport)
		# http://vfrmap.com/?type=vfrc&lat=41.151&lon=-81.415&zoom=10
		latlong = airport.details[:Location]["Lat/Long: "][2].split(" / ")
		lat = latlong[0].to_f
		long = latlong[1].to_f
		chart_url = "http://vfrmap.com/?type=vfrc&lat=#{lat}&lon=#{long}&zoom=10"
		print "Opening chart for #{airport.name}"
		slow_ellipsis
		Launchy.open(chart_url)
		sleep(1)

	end

	# def show_runway_info(airport)
	# 	rws = airport.runways
	# 	rws.each.with_index(1){ |rw, i| puts "\n#{i}: #{rw.name} is #{rw.dimensions} and is made of #{rw.surface}" }
	# end

## End locate airport chain


## Begin plan route chain
	def plan_route
		puts "planning"
	end

## End plan route chain

## Instance and class variables/methods below

	def gets_and_hand_off(function = false)

		self.choice = gets.strip.downcase
		send(function) if (function && self.choice != "exit")

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

		goodbyes = [
			"Roger that!",
			"Clear skys!",
			"Don't forget to close your flight plan!",
			"Any landing you can walk away from...",
			"Tie downs, check.  Wheel chocks, check.",
			"Barrel Roll!"
		]

		puts "\n#{goodbyes.shuffle[0]}\n\n"

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
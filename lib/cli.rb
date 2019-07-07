=begin

NEXT TODO:

fix runways
fix formatting on aiport statistics


=end




class AirportFinder::CLI

	def call

		@place = ""
		@radius = 20
		@choice = nil
		@matches = []
		@airport = nil

		welcome

	end

	def welcome

			#TODO-TIME
			#maybe try to put a logo here if you have time 
			#look into  colors for the text if theres time
			system "clear" # add this to a few locations to keep the screen clean TODO-TIME
			puts "\nWelcome to Airport Finder!"
			
			main_menu

	end

	def main_menu

		while self.choice != 'exit' do

			puts "\nWhat would you like to do?"
			puts "Please select from the following choices:"
			puts "1: Locate an airport by city/state or zip code"
			puts "2: Plan a route between two airports"
			puts "Enter the number of your choice or type 'exit' to exit."

			self.choice = gets.strip

			case self.choice
			when "1"
				locate_airport
			when "2"
				plan_route
			when "exit"
				exit
			else
				self.whoops
			end

		end
	end


### Begin locate airport chain
	def locate_airport

		#TODO-NEXT
		#what to do here......
		#X ask for the city/state or zip code or airport identifier? (will i use this? if there's time?)
		#hand off to Search to get the info from the scraper if it doesn't already exist
		#Search should return the first round search (matches within radius) or return nil if no matches
		#if there are matches:
		#cli should display the matches and ask for next round of input
		#else, ask for new input (give option to quit)
		#user chooses an airport
		#hand off airport to Airport which will return airport info to display
		#ask what info is wanted, give option to see charts

		ok_one = false
		ok_two = false

		while !ok_one do
			puts "\nPlease enter the city and state OR the zip code to search"
			puts "Example: 'Albuquerque, New Mexico'; Example: '90210'"

			self.place = gets.strip #sanatize this

			#maybe add a break to catch if 'exit' is entered in here

			puts "\nYou entered #{self.place}.  Is this ok? Enter 'y' or 'n'"

			ok_one = ok?

		end

		while !ok_two do

			puts "\nPlease enter the maximum search radius in nm"
			puts "Or press enter to accept the default of 20nm"
			puts "Min radius is 1nm. Max radius is 200nm"

			entry = gets.strip

			if entry == "" || entry == "0"
				self.radius = 20
				puts "\nSearch radius is #{radius}nm.  Is this ok? Enter 'y' or 'n'"
				ok_two = ok?
			elsif entry.to_i != 0
				self.radius = [entry.to_i, 200].min
				puts "\nSearch radius is #{radius}nm. Is this ok? Enter 'y' or 'n'"
				ok_two = ok?
			else
				self.whoops
			end

			#maybe add a break to catch if 'exit' is entered in here
				
		end

		self.matches = airport_menu(Search.find_or_create(self.place, self.radius))
	end

	def airport_menu(matches)
		count = matches.length
		if count == 0
			puts "Your search of #{self.place} with a radius of #{self.radius} did not return any matches."
			puts "Would you like to try again? Enter 'y' for yes or 'n' for no.(y)"

			continue = gets.strip.downcase

			case continue
			when 'y'
				locate_airport
			when 'n'
				nil
			when ''
				locate_airport
			else
				while (continue != "y" && continue != "n") do
					self.whoops
					puts "Would you like to try again? Enter 'y' for yes or 'n' for no.(y)"
					continue = gets.strip.downcase
				end
			end
		else
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
		end
		airport_select(matches) if continue != "n"
	end

	def airport_select(matches)
		puts "Please enter the number of the airport."
		choice = gets.strip
		while choice.to_i == 0 || choice.to_i > matches.length do
			self.whoops # add in a  condition for input of 'exit'
			choice = gets.strip
		end
		# puts matches[choice.to_i - 1][4] # TODO find or create airport
		selection = matches[choice.to_i - 1]
		airport = Airport.find_or_create(selection[0].strip, selection[2].strip, selection[4])
		learn_more(airport)
	end

	def learn_more(airport)
		max_choice = airport.details.keys.count + 3
		puts "\n #{airport.identifier} - #{airport.name}:"
		airport.details.keys.each.with_index(1){ |key, i| puts "#{i}:#{' ' * (3 - i.to_s.chars.count)}#{key}"}
		puts "#{max_choice - 2}:#{' ' * (3 - (max_choice - 1).to_s.chars.count)}Runways"
		puts "#{max_choice - 1}:#{' ' * (3 - (max_choice - 1).to_s.chars.count)}View on chart"
		puts "#{max_choice}:#{' ' * (3 - max_choice.to_s.chars.count)}Done"
		puts "\nWould you like to learn more about this airport?"
		puts "Enter the number of the topic you want to know more about."
		choice = gets.strip
		while !choice.to_i.between?(1,max_choice)
			self.whoops
			puts "Enter the number of the topic you want to know more about."
			choice = gets.strip
		end
		while choice.to_i != max_choice
			case choice.to_i
			when (1..max_choice - 3)
				show_details(airport.details, choice.to_i)
			when max_choice - 2
				show_runway_info(airport)
			when max_choice - 1
				#get the coordinates and parse to chart url and open url
				show_chart(airport)
			end
			puts "\nWhat else would you like to see?"
			airport.details.keys.each.with_index(1){ |key, i| puts "#{i}:#{' ' * (3 - i.to_s.chars.count)}#{key}"}
			puts "#{max_choice - 2}:#{' ' * (3 - (max_choice - 1).to_s.chars.count)}Runways"
			puts "#{max_choice - 1}:#{' ' * (3 - (max_choice - 1).to_s.chars.count)}View on chart"
			puts "#{max_choice}:#{' ' * (3 - max_choice.to_s.chars.count)}Done"
			puts "\nEnter the number of the topic you want to know more about."
			choice = gets.strip
			while !choice.to_i.between?(1,max_choice)
				self.whoops
				puts "Enter the number of the topic you want to know more about."
				choice = gets.strip
			end
		end
		return_to_main_menu

	end

	def show_details(details, choice)
		category = details.keys[choice - 1]
		puts "\nShowing #{category}\n"
		details[category].each_pair.with_index do |(topic, data), i|
			puts "#{topic}#{data.join("\n#{" " * (topic.chars.count)}")}" if (choice != 4 && choice != 6)
			puts "#{data}\n" if choice == 4
			if choice == 6
				# binding.pry
				puts "#{topic}#{data}"
			end
		end

	end

	def show_chart(airport)
		puts "I will show chart"
	end

	def show_runway_info(airport)
		rws = airport.runways
		rws.each.with_index(1){ |rw, i| puts "\n#{i}: #{rw.name} is #{rw.dimensions} and is made of #{rw.surface}" }
	end

## End locate airport chain


## Begin plan route chain
	def plan_route
		puts "planning"
	end

## End plan route chain

## Instance and class variables/methods below
	def return_to_main_menu
		print "\nReturning to main menu"
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

	def ok?
		ok = gets.strip.downcase

			case ok
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
	def whoops
		puts "\nWhoops!  I don't understand that.  Let's try again."
	end

	def choice=(choice)
		@choice = choice
	end

	def choice
		@choice
	end

	def place=(place = "")
		@place = place
	end

	def place
		@place
	end

	def radius=(radius = 20)
		@radius = [radius.to_i, 1].max
		@radius = [@radius, 200].min
	end

	def radius
		@radius
	end

	def matches=(matches)
		@matches = matches
	end

	def matches
		@matches
	end

	def airport=(airport)
		@airport = airport
	end

	def airport
		@airport
	end

end
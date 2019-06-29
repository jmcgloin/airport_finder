class AirportFinder::CLI

	def call

		@place = ""
		@radius = 20
		self.choice = nil
		self.matches = []
		self.airport = nil

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
		#hand off aiport to Airport which will return airport info to display
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
				radius = 20
				puts "\nSearch radius is #{radius}nm.  Is this ok? Enter 'y' or 'n'"
				ok_two = ok?
			elsif entry.to_i != 0
				radius = [entry.to_i, 200].min
				puts "\nSearch radius is #{radius}nm. Is this ok? Enter 'y' or 'n'"
				ok_two = ok?
			else
				self.whoops
			end

			#maybe add a break to catch if 'exit' is entered in here
				
		end

		self.matches = airport_menu(Search.find_or_create(self.place, radius))
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
				self.whoops
			end
		else
			puts "Here are your matches"
			puts "#: Identifier | Name                                              | Distance(nm)"
			matches.each.with_index(1) do |match, i|
				# 1: Identifier | Name                                              | Distance
				if match[1].length >= 50
					airport_name = match[1].slice(0,50)
				else
					airport_name = match[1] + " " * (50 - match[1].length )
				end
				puts "#{i}: #{match[0]}        | #{airport_name}| #{match[2]}"
			end
			# this will also diplay airport identifier, name, distance, and use?
			#next is to ask to select which airport to learn more about
			#get info from Airport object
		end
		learn_more(matches)
	end

	def airport_select(matches)
		puts "Please enter the number of the airport."
		choice = gets.strip
		while choice.to_i == 0 do
			self.whoops # add in a  condition for input of 'exit'
		end

		airport = Airport.find(matches[choice.to_i - 1][0])
	end

## End locate airport chain


## Begin plan route chain
	def plan_route
		puts "planning"
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

## End plan route chain

## Instance and class variables/methods below
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

end
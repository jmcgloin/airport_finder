class AirportFinder::CLI

	def call

		@place = ""
		@radius = 20
		self.choice = nil

		welcome

	end

	def welcome

			#TODO-TIME
			#maybe try to put a logo here if you have time 
			#look into  colors for the text if theres time
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

			choice = gets.strip

			case choice
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

	def locate_airport
		puts "locating"

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
				
		end

		airport_menu(Search.find_or_create(self.place, radius))
		#this returns the search which will contain the info on the matches in array
		#i.e. an array of airport objects

	end

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

	def airport_menu(airport_matches)
		if airport_matches.length == 0
			puts "Your search of #{self.place} with a radius of #{self.radius} did not return any matches."
			puts "Would you like to try again? Enter 'y' for yes or 'n' for no."
		end
	end

	def ok?
		ok = gets.strip.downcase

			case ok
			when 'y'
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

end
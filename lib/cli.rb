class AirportFinder::CLI

	def call

		welcome

	end

	def welcome

			#TODO-TIME
			#maybe try to put a logo here if you have time 
			#look into  colors for the text if theres time
			puts "\nWelcome to Airport Finder!"
			
			menu

	end

	def menu

		choice = nil

		while choice != 'exit' do

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
				puts "\nWhoops! I don't understand that.  Lets try again"
			end

		end
	end

	def locate_airport
		puts "locating"

		#TODO-NEXT
		#what to do here......
		#X ask for the city/state or zip code or airport identifier? (will i use this? if there's time?)
		#hand off to the scraper to get the information
		#if the data comes back good
			#show the list of possible airports to view
			#gets choice to choose and airport or try the search again
		#else whoops and gives chance to try again
		#user chooses an airport
		#new airport -> new runway, new fsbo

		#maybe a choice showing current airports (those in Airport.all) to choose from without scraping again?

		ok_one = false
		ok_two = false
		place = ""
		radius = 20

		while !ok_one do
			puts "\nPlease enter the city and state OR the zip code to search"
			puts "Example: 'Albuquerque, New Mexico'; Example: '90210'"

			place = gets.strip

			puts "\nYou entered #{place}.  Is this ok? Enter 'y' or 'n'"

			ok_one = ok?

		end

		while !ok_two do

			puts "\nPlease enter the maximum search radius in nm"
			puts "Or press enter to accept the default of 20nm"
			puts "Max radius is 200nm"

			entry = gets.strip

			if entry == "" || entry == "0"
				radius = 20
				puts "\nYou entered #{radius}.  Is this ok? Enter 'y' or 'n'"
				ok_two = ok?
			elsif entry.to_i != 0
				radius = [entry.to_i, 200].min
				puts "\nSearch radius is #{radius}nm. Is this ok? Enter 'y' or 'n'"
				ok_two = ok?
			else
				puts "\nWhoops!  I don't understand that.  Let's try again."
			end
				
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
				puts "\nWhoops!  I don't understand that.  Let's try again."
				return false
			end
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

end
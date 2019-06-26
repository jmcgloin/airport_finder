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
		#ask for the city/state or zip code or airport identifier? (will i use this? if there's time?)
		#hand off to the scraper to get the information
		#if the data comes back good
			#show the list of possible airports to view
			#gets choice to choose and airport or try the search again
		#else whoops and gives chance to try again
		#user chooses an airport
		#new airport -> new runway, new fsbo

		#maybe a choice showing current airports (those in Airport.all) to choose from without scraping again?

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
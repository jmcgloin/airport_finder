class AirportFinder::CLI

	def call

		choice = nil

		while choice != 'exit' do

			# add all the cli interactions here

			puts "Welcom to Airport Finder!"
			puts "What would you like to do?"
			puts "Please select from the following choices:"
			puts "1: Locate an airport by city/state or zip code"
			puts "2: Plan a route between two airports"
			puts "Or type 'exit' to exit."
			puts "Enter the number of your choice."

			choice = gets.strip

		end

	end

	def locate_airport
		
	end

end
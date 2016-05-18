class CourseraController < ApplicationController
	include HTTParty

	def new 
	end

	def search_form 

	end

	def search

		search_string = params[:search].gsub(/\s+/,"+")
		api2 = "https://api.coursera.org/api/courses.v1?q=search&query=" + search_string + "&includes=instructorIds,partnerIds,partnerLogo&fields=instructorIds,partnerIds,partnerLogo"
	#hitting the course search api	
		@courses = HTTParty.get(api2)

	#making the url for partner and instructor api for bulk hitting
		partner_api_url_for_bulk = "https://api.coursera.org/api/partners.v1?ids="
		instructor_api_url_for_bulk = "https://api.coursera.org/api/instructors.v1?ids="
		number_of_courses = [@courses["elements"].size() , 15].min
		for i in 0..number_of_courses - 2
			partner_api_url_for_bulk = partner_api_url_for_bulk + @courses["elements"][i]["partnerIds"][0] + ","
			instructor_api_url_for_bulk = instructor_api_url_for_bulk + @courses["elements"][i]["instructorIds"][0] + ","
		end
		partner_api_url_for_bulk = partner_api_url_for_bulk + @courses["elements"][@courses["elements"].size() - 1]["partnerIds"][0]
		instructor_api_url_for_bulk = instructor_api_url_for_bulk + @courses["elements"][@courses["elements"].size() - 1]["instructorIds"][0]
		
	#hitting the partner api
		@partners = HTTParty.get(partner_api_url_for_bulk)
		@details_of_partners_mapping = {}
	#mapping in a hash 
		for i in 0..@partners["elements"].size() - 1
			@details_of_partners_mapping[@partners["elements"][i]["id"].to_s] = @partners["elements"][i]["name"] 
		end
	#hitting the instructor api	
		@instructors = HTTParty.get(instructor_api_url_for_bulk)
		@details_of_instructors_mapping = {}
		for i in 0..@instructors["elements"].size() - 1
			@details_of_instructors_mapping[@instructors["elements"][i]["id"].to_s] = @instructors["elements"][i]["fullName"] 
		end
	end
end

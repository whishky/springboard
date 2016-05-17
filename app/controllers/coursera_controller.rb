class CourseraController < ApplicationController
	include HTTParty

	def new 
	end

	def search_form 

	end

	def search
		binding.pry
		#api = "https://api.coursera.org/api/courses.v1?q=search&query="+params[:search]
		api2 = "https://api.coursera.org/api/courses.v1?q=search&query=" +params[:search]+"&includes=instructorIds,partnerIds&fields=instructorIds,partnerIds"
		@courses = HTTParty.get(api2)
		partner_api_url_for_bulk = "https://api.coursera.org/api/partners.v1?ids="
		instructor_api_url_for_bulk = "https://api.coursera.org/api/instructors.v1?ids="
		for i in 0..@courses["elements"].size() - 2
			partner_api_url_for_bulk = partner_api_url_for_bulk + @courses["elements"][i]["partnerIds"][0] + ","
			instructor_api_url_for_bulk = instructor_api_url_for_bulk + @courses["elements"][i]["instructorIds"][0] + ","
		end
		partner_api_url_for_bulk = partner_api_url_for_bulk + @courses["elements"][@courses["elements"].size() - 1]["partnerIds"][0]
		instructor_api_url_for_bulk = instructor_api_url_for_bulk + @courses["elements"][@courses["elements"].size() - 1]["instructorIds"][0]
		@partner = HTTParty.get(partner_api_url_for_bulk)
			#details[i][:ptname] = @partner["elements"][0]["name"]
			#details[i][:partnerId] = @courses["elements"][i]["partnerIds"]
			#details[i][:instructorId] = @courses["elements"][i]["instructorIds"]
		@instructor = HTTParty.get(instructor_api_url_for_bulk)
			#details[i][:itname] = @instructor["elements"][0]["name"]

	end
end

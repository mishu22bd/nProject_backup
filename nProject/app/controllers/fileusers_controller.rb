=begin     

Author: M Rezaur Rahman
This file is associated with file permission.


=end




class FileusersController < ApplicationController


  


def edit
@fileuser =  Fileuser.find(params[:id])
end


def update
		@fileuser =  Fileuser.find(params[:permission_flag])

		@fileuser.update_attributes!(params[:permission_flag])

		redirect_to '/'


end




def edit_multiple
	puts 'in edit multiple method'
	puts params[:fileuser_ids]
	puts 'end'
	if params[:fileuser_ids] == nil
		redirect_to '/'
	else
	#@fileusers =  Fileuser.find(params[:fileuser_ids])
	#@fileusers = Fileuser.()
	end
end



def update_multiple


	Fileuser.update(params[:fileusers].keys,params[:fileusers].values)
	attachment_id_of_file =  params[:fileusers].values[0][:attachment_id]
	#puts attachment_id_of_file
	#project_ids = Attachment.where(:id => attachment_id_of_file).pluck(:container_id)
	project_ids =  Boxelement.where(:id => attachment_id_of_file).pluck(:project_id)

	#puts project_ids
	#Rails.logger.info "Hello"
	#for project_id in project_ids

	if project_ids[0]	
	    redirect_to project_files_path(project_ids[0])
	else
		redirect_to fileviews_path
	end

 
end


end 
class ApplicationController < ActionController::Base
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

   def record_not_found
     render :text => "404 Not Found", :status => 404
   end
   
end

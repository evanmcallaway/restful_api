class Response < ActiveRecord::Base

  belongs_to :question
  validates_presence_of :value 
  
end
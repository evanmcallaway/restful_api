class Question < ActiveRecord::Base
  
  has_many :responses, dependent: :destroy
  has_one :answer, ->{ where correct: true }, class_name: "Response"
  has_many :distractors, ->{ where correct: false }, class_name: "Response"
  
  validates_presence_of :text
  validates_presence_of :answer
  
end
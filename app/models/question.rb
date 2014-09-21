class Question < ActiveRecord::Base
  
  CATEGORIES = {
    '+' => 'Addition',
    '-' => 'Subtraction',
    '*' => 'Multiplication',
    '/' => 'Division',
    nil => 'Unknown'
  }
  
  has_many :responses, dependent: :destroy
  has_many :distractors
  has_one :answer
  
  accepts_nested_attributes_for :answer
  
  before_save :set_category
  
  validates_presence_of :answer
  validates_presence_of :query
  validates_uniqueness_of :query
  validate :validate_responses
  
  def answer_value
    self.answer.value
  end
  
  # returns a comma separated list of all distractors
  def distractors_list
    self.distractors.map { |distractor| distractor.value }.join(', ')
  end
  
  # accepts a comma separated string or array of distractors; clears the existing distractor list and assigns the new list to the question without saving
  def distractors_list=(distractor_params)
    self.distractors.destroy_all
    distractor_params = distractor_params.split(',').map(&:strip) if distractor_params.is_a?(String)
    distractor_params.each do |distractor|
      self.distractors << Distractor.new(value: distractor)
    end
  end
  
  # niavely set categories for simple math problems when they are created or updated
  def set_category
    match_data = /^What is [-]?\d+\s*(?<operation>[\+\-\*\/])\s*[-]?\d+\?$/.match(self.query) || {}
    self.category = CATEGORIES[match_data[:operation]]
  end

  def validate_responses
    errors.add(:base, 'A question must have at least one distractor') if self.distractors.empty?
  end
  
  # returns a filtered set of users
  def self.filter_and_sort(filter, order)
    questions = Question.all
    if filter
      questions = questions.where(category: filter[:category]) if filter[:category]
      if filter[:search]
        questions = questions.where('query LIKE ?', "%#{filter[:search]}%")
      end
    end
    if order
      if Question.column_names.include?(order[:column])
        questions = questions.order("#{order[:column]} #{order[:direction]}")
      elsif order[:column] == 'answer'
        questions = questions.joins(:answer).order("responses.value #{order[:direction]}")
      end
    end
    questions
  end
  
end
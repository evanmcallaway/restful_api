namespace :import do
  
  task :questions => :environment do
    require 'csv'
    raise 'required parameter CSV_FILE is missing' if ENV['CSV_FILE'].blank?
  
    # open the csv file
    csv_options = {
      headers: true,
      header_converters: :symbol,
      col_sep: '|'
    }
    csv_file = CSV.read(ENV['CSV_FILE'], csv_options)
    
    csv_file.each do |row|
      Question.transaction do
        question = Question.new(text: row[:question])
        
        # create the answer and distractors
        question.answer = Response.new(value: row[:answer], correct: true)
        row[:distractors].split(',').map(&:strip).each do |distractor|
          question.distractors << Response.new(value: distractor, correct: false)
        end
        
        # save the question and associated answer and distractors
        question.save!
      end
    end
  
  end
  
end
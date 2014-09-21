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
        question = Question.create!(query: row[:question], distractors_list: row[:distractors], answer: Answer.new( value: row[:answer] ))
      end
    end
  
  end
  
end
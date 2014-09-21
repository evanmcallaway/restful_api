class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :query
      t.string :category
    end
    
    create_table :responses do |t|
      t.references :question
      t.string :value
      t.string :type
    end
  end
end

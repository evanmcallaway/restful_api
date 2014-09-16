class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :responses do |t|
      t.references :question
      t.string :value
      t.boolean :correct
      t.timestamps
    end
  end
end

class QuestionsController < ApplicationController
  
  DEFAULT_PAGE_SIZE = 10
  
  before_filter do
    params[:filter] ||= {}
    params[:order] ||= {}
    @filter = Filter[params[:filter].delete_if { |key, value| value.empty? } || {}]
  end
  
  # POST /questions
  def create
    @question = Question.new(question_params)
    if @question.save
      respond_to do |format|
        format.html { redirect_to questions_path }
        format.xml { render xml: @question.to_xml(include: [:responses]) }
        format.json { render json: @question.to_json(include: [:responses]) }
      end
    else
      respond_to do |format|      
        format.html { render action: "new" }
        format.xml { render xml: @question.errors.to_xml }
        format.json { render json: @question.errors.to_json }
      end
    end
  end
  
  # DELETE /questions/:id
  def destroy
    @question = Question.find(params[:id])
    if @question.destroy
      respond_to do |format|
        format.html { redirect_to questions_path }
        format.xml { render xml: @question.to_xml(include: [:responses]) }
        format.json { render json: @question.to_json(include: [:responses]) }
      end
    else
      respond_to do |format|
        format.html { redirect_to questions_path }
        format.json { render xml: @question.errors.to_xml, status: :unprocessable_entity , :status => 400 }
        format.json { render json: @question.errors.to_json, status: :unprocessable_entity , :status => 400 }
      end
    end
  end
  
  # GET /questions/:id/edit
  def edit
    @question = Question.find(params[:id])
  end
  
  # GET /questions
  def index
    @questions = Question.filter_and_sort(params[:filter], params[:order]).paginate(:page => params[:page], per_page: (params[:page_size] || DEFAULT_PAGE_SIZE))
    
    respond_to do |format|
      format.html
      format.xml { render xml: @questions.to_xml(include: [:responses]) }
      format.json { render json: @questions.to_json(include: [:responses]) }
    end
  end
  
  # GET /questions/new
  def new
    @question = Question.new
    @question.build_answer
  end
  
  # get /questions/:id
  def show
    @question = Question.find(params[:id])
    respond_to do |format|
      format.html
      format.xml { render xml: @question.to_xml(include: [:responses]) }
      format.json { render json: @question.to_json(include: [:responses]) }
    end
  end
  
  # put /questions/:id
  def update
    @question = Question.find(params[:id])
    begin
      Question.transaction do
        @question.update_attributes!(question_params)
      end
      respond_to do |format|
        format.html { redirect_to questions_path }
        format.xml { render xml: @question.to_xml(include: [:responses]) }
        format.json { render json: @question.to_json(include: [:responses]) }
      end
    rescue ActiveRecord::RecordInvalid => e
      respond_to do |format|      
        format.html { render action: "edit" }
        format.xml { render xml: @question.errors.to_xml }
        format.json { render json: @question.errors.to_json }
      end
    end
  end
  
  private
  
  def question_params
    params.require(:question).permit(:query, :distractors_list, answer_attributes: [:id, :value])
  end
  
end
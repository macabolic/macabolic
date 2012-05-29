class AnswersController < ApplicationController
  #before_filter :show_invitation_notice

  # POST /answers
  # POST /answers.xml
  def create
    @answer = Answer.new(params[:answer])
    #@answer.question_id = params[:question_id]
    #@answer.user_id = current_user.id

    logger.debug "========================================="
    logger.debug "Answer [content]: #{@answer.content}"
    logger.debug "Answer [question_id]: #{@answer.question_id}"
    logger.debug "Answer [product_id]: #{@answer.product_id}"
    logger.debug "Answer [user_id]: #{@answer.user_id}"
    logger.debug "========================================="

    @answer.save    
    @question = Question.find(params[:question_id])
  end
  
  def vote
    logger.debug "vote for the answer..."
    logger.debug "vote value: #{params[:vote]}"
    # 1. Check if the current_user has an entry in the answer_response.
    @answer_response = AnswerResponse.where("user_id = ? and answer_id = ?", current_user.id, params[:id])
    if @answer_response.exists?
      logger.debug "Answer Response exists: #{@answer_response.first}." 
      if @answer_response.first.update_attributes(:response_for => params[:vote])     
        logger.debug "Answer response updated: #{params[:vote]}"
      else
        logger.debug "Some problem updating the answer response: #{@answer_response.first.errors}"
      end
    else
      @answer_response = AnswerResponse.new
      @answer_response.answer_id = params[:id]
      @answer_response.response_for = params[:vote]
      @answer_response.user = current_user
      
      if @answer_response.save
        logger.debug "Answer Response newly created: #{@answer_response}."
      else
        logger.debug "Sorry, for some reason your vote is not valid!"
      end
    end
    
    @answer_id = params[:id]
    @vote = params[:vote]
    @vote_useful_count = AnswerResponse.where("answer_id = ? and response_for = ?", params[:id], true).size
  end
    
end

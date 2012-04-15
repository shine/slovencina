require 'lib/leven'

class AttemptsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def new
    @word = Word.get_random_word(current_user)
    @attempt = Attempt.new(:word_id => @word.id)

    respond_to do |format|
      format.html
      format.json { render :json => @word }
    end
  end
  
  def create
    word = Word.find params[:attempt][:word_id]
    
    attempt = Attempt.new
    attempt.word_id = params[:attempt][:word_id]
    attempt.is_correct = !!(params[:attempt][:version] == current_user.to_for_word(word))
    
    # ld is method for levenstine range calculation. method defined in libs
    attempt.distance = ld(current_user.to_for_word(word), params[:attempt][:version])
    attempt.user_id = current_user.id
    attempt.save!
    
    respond_to do |format|
      format.html do
        if attempt.is_correct
          flash[:notice] = "Верно. #{current_user.from_for_word(word).capitalize} переводится как #{current_user.to_for_word(word)}"
        else
          flash[:error] = "Неверно. #{current_user.from_for_word(word).capitalize} переводится не как #{params[:attempt][:version]}, а как #{current_user.to_for_word(word)}"
        end
        
        redirect_to :action => :new
      end
      format.json do
        render :json => [attempt.is_correct, params[:attempt][:version], current_user.to_for_word(word), Word.get_random_word]
      end
    end
  end
end
require 'lib/leven'

class AttemptsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def new
    @word = Word.get_random_word
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
    attempt.is_correct = !!(params[:attempt][:version] == word.slov)
    
    # ld is method for levenstine range calculation. method defined in libs
    attempt.distance = ld(word.slov, params[:attempt][:version])
    attempt.save!
    respond_to do |format|
      format.html do
        if attempt.is_correct
          flash[:notice] = "Верно. #{word.rus.capitalize} переводится как #{word.slov}"
        else
          flash[:error] = "Неверно. #{word.rus.capitalize} переводится не как #{params[:attempt][:version]}, а как #{word.slov}"
        end
        
        redirect_to :action => :new
      end
      format.json do
        render :json => [attempt.is_correct, params[:attempt][:version], word.slov, Word.get_random_word]
      end
    end
  end
end
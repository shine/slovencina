class WordsController < ApplicationController
  def new
    @word = Word.new
    @word.category_id = session[:current_category_id] if session[:current_category_id]
  end
  
  def create
    @word = Word.new params[:word]
    @word.save!

    session[:current_category_id] = @word.category_id
    
    redirect_to :back
  end
  
  def show
    @word = Word.first(:conditions => {:id => params[:word_id]}, :include => :attempts)
  end
end

require 'test_helper'

class WordsControllerTest < ActionController::TestCase
  test "there should be form for new word entering" do
    get :new
    
    assert_response :success
    assert_not_nil assigns(:word)
 end
 
  test "word creation form should save category of previous entered word" do
    session[:current_category_id] = 7
   
    get :new
    
    assert_response :success
    assert_not_nil assigns(:word)
    assert_equal 7, assigns(:word).category_id
 end
 
  test "word should be created" do
   @request.env["HTTP_REFERER"] = "/words/new"
    category_of_new_word = 4
    
    assert_difference('Word.count', 1) do
      post :create, :word => {:rus => 'пиво', :slov => 'pivo', :category_id => category_of_new_word}
   end
    
    assert_response :redirect
    assert_equal category_of_new_word, session[:current_category_id]
 end
 
  test "word should be visible by show action" do
    w = Word.last
    assert w
   
    get :show, :word_id => w.id
   
    assert_response :success
    assert_not_nil assigns(:word)
    assert_equal w.id, assigns(:word).id
 end
end

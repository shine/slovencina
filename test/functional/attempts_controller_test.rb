require 'test_helper'

class AttemptsControllerTest < ActionController::TestCase
   test "we can get form for new attempt" do
    get :new
    
    assert_response :success
    assert_not_nil assigns(:word)
    assert_not_nil assigns(:attempt)
  end
  
   test "we can give wrong answer" do
    w = Word.last
    assert_not_nil w
   
    post :create, :attempt => {:word_id => w.id, :version => w.slov.reverse}
    
    assert_response :redirect
    assert_nil flash[:notice]
    assert_not_nil flash[:error]
  end
  
   test "we can give correct answer" do
    w = Word.last
    assert_not_nil w
   
    post :create, :attempt => {:word_id => w.id, :version => w.slov}
    
    assert_response :redirect
    assert_nil flash[:error]
    assert_not_nil flash[:notice]
  end
end

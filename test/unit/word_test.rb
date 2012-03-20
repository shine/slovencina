require 'test_helper'

class WordTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "levenstine range" do
    words = [
              ['syr', 'sýr'],
              ['stryko', 'strýko'],
              ['záclona', 'zaclona'],
              ['mäso', 'maso'],
              ['something', 'other'],
              ['ísť', 'prist'],
              ['priať', 'chcieť']
            ]
            
      words.each do |pair|
        first, second = pair
        assert ld(first, second)
    end
  end
  
  test "levenstine strings with different lengths" do
    words = [
              ['syr', ''],
              ['', 'strýko'],
              ['záclona', ''],
              ['', 'maso'],
              ['something', ''],
              ['', 'prist'],
              ['priať', '']
            ]
    
      words.each do |pair|
        first, second = pair
        assert ld(first, second) > 0
    end
  end
  
  test "words are able to find total number of related attempts, number of good attempts and bad ones" do
    c = Category.create! :name => 'shopping'
    shopping = Word.create! :rus => 'покупки', :slov => 'nákup'
    cashier = Word.create! :rus => 'кассирша', :slov => 'pokladníčka'
    
   Attempt.create! :word_id => shopping.id, :is_correct => true, :distance => 0
   Attempt.create! :word_id => shopping.id, :is_correct => false, :distance => 1
   Attempt.create! :word_id => shopping.id, :is_correct => false, :distance => 2
   Attempt.create! :word_id => shopping.id, :is_correct => false, :distance => 3
    
   Attempt.create! :word_id => cashier.id, :is_correct => true, :distance => 0
   Attempt.create! :word_id => cashier.id, :is_correct => false, :distance => 3
   
     assert_equal 4, shopping.total_attempts
     assert_equal 3, shopping.bad_attempts
     assert_equal 1, shopping.good_attempts
 end
 
  test "words are able to find percent of good attempts and bad ones" do
    c = Category.create! :name => 'shopping'
    shopping = Word.create! :rus => 'покупки', :slov => 'nákup'
    
   Attempt.create! :word_id => shopping.id, :is_correct => true, :distance => 0
   Attempt.create! :word_id => shopping.id, :is_correct => false, :distance => 1
   Attempt.create! :word_id => shopping.id, :is_correct => false, :distance => 2
   Attempt.create! :word_id => shopping.id, :is_correct => false, :distance => 3
   
     assert_equal 0.25, shopping.good_attempts_percent
     assert_equal 0.75, shopping.bad_attempts_percent
 end

  test "words are able to find percent of good attempts and bad ones even if there is no any attempt" do
    c = Category.create! :name => 'shopping'
    shopping = Word.create! :rus => 'покупки', :slov => 'nákup'
    
     assert_equal 0.0, shopping.good_attempts_percent
     assert_equal 0.0, shopping.bad_attempts_percent
 end
 
  test "we should be able to find random words" do
   Word.all.map(&:destroy)
   Category.all.map(&:destroy)
   
    c = Category.create! :name => 'shopping'
    shopping = Word.create! :rus => 'покупки', :slov => 'nákup', :category_id => c.id
    cashier = Word.create! :rus => 'кассирша', :slov => 'pokladníčka', :category_id => c.id
    view = Word.create! :rus => 'вид', :slov => 'výchľad', :category_id => c.id
    shirt = Word.create! :rus => 'рубашка', :slov => 'košeľa', :category_id => c.id
    hat = Word.create! :rus => 'шляпа', :slov => 'klobúk', :category_id => c.id
    pork = Word.create! :rus => 'свинина', :slov => 'bravčové mäso', :category_id => c.id
   
   assert_equal 6, c.words.size
   assert_equal 6, Word.all.size
    
  Attempt.create! :word_id => shopping.id, :is_correct => true, :distance => 0
  Attempt.create! :word_id => cashier.id, :is_correct => true, :distance => 0
  Attempt.create! :word_id => view.id, :is_correct => true, :distance => 0
  Attempt.create! :word_id => shirt.id, :is_correct => true, :distance => 0
  Attempt.create! :word_id => hat.id, :is_correct => true, :distance => 0
  Attempt.create! :word_id => pork.id, :is_correct => true, :distance => 0

  word_variants = []  
   30.times do
    word_variants << Word.get_random_word
  end  
  
   assert_equal 6, word_variants.uniq.size
   assert_equal [shopping.id, cashier.id, view.id, shirt.id, hat.id, pork.id].sort, word_variants.uniq.map(&:id).sort
 end
 
  test "if there were no attempts then both global average levenstine distance and same distance for any word should be zero" do
  Attempt.all.map(&:destroy)
  
    c = Category.create! :name => 'shopping'
    shopping = Word.create! :rus => 'покупки', :slov => 'nákup', :category_id => c.id

    assert_equal 0, Word.average_leven(1.year)  
    assert_equal 0, shopping.average_leven(1.year)  
 end
 
  test "if there are attempts then both global average levenstine distance and same distance for any word should be numbers" do
  Attempt.all.map(&:destroy)
  
    c = Category.create! :name => 'shopping'
    shopping = Word.create! :rus => 'покупки', :slov => 'nákup'
    cashier = Word.create! :rus => 'кассирша', :slov => 'pokladníčka'
    
   Attempt.create! :word_id => shopping.id, :is_correct => true, :distance => 0
   Attempt.create! :word_id => shopping.id, :is_correct => false, :distance => 1
   Attempt.create! :word_id => shopping.id, :is_correct => false, :distance => 2
   Attempt.create! :word_id => shopping.id, :is_correct => false, :distance => 3
    
   Attempt.create! :word_id => cashier.id, :is_correct => true, :distance => 0
   Attempt.create! :word_id => cashier.id, :is_correct => false, :distance => 4
   
    assert_equal 10.0/6, Word.average_leven(1.year)  
    assert_equal 1.5, shopping.average_leven(1.year)  
    assert_equal 2.0, cashier.average_leven(1.year)
 end

end

class Word < ActiveRecord::Base
  has_many :attempts
  belongs_to :category

  attr_accessor :total
  attr_accessor :bad
  attr_accessor :good

  def total_attempts
    @total ||= self.attempts.size
  end
  
  def bad_attempts
    @bad ||= self.attempts.select{|item| !item.is_correct}.count
  end
  
  def good_attempts
    @good ||= self.attempts.select{|item| item.is_correct}.count
  end
  
  def bad_attempts_percent
    if total_attempts > 0
        bad_attempts/(total_attempts.to_f)
    else
      0.0
    end
  end
  
  def good_attempts_percent
    if total_attempts > 0
        good_attempts/(total_attempts.to_f)
    else
      0.0
    end
  end
  
  def self.get_random_word
    words = Word.includes(:attempts).all
    
    weights = words.map do |w|
                freq = (w.total_attempts == 0 ? 30000 : 3.0/w.total_attempts)
                corr = (w.good_attempts_percent == 0.0 ? 10000 : 10.0/w.good_attempts_percent)
                          
                (1*freq*corr).ceil
              end
                        
    weights ||= Array.new(words.size, 1.0)
    total = weights.inject(0.0) {|t,w| t+w}
    point = rand * total
      
    words.zip(weights).each do |n,w|
      return n if w >= point
      point -= w
    end
  end
  
  def average_leven period
    attempts = self.attempts.all(:select => 'distance', :conditions => ['created_at > ?', period.ago])
    
    if attempts.empty?
      0
    else
      (attempts.inject(0){|sum, item| sum + item.distance})/attempts.size.to_f
    end
  end
  
  def self.average_leven period
    attempts = Attempt.all(:select => 'distance', :conditions => ['created_at > ?', period.ago])
    
    if attempts.empty?
      0
    else
      (attempts.inject(0){|sum, item| sum + item.distance})/attempts.size.to_f
    end
  end
end

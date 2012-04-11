class Word < ActiveRecord::Base
  has_many :attempts
  belongs_to :category

  attr_accessor :total
  attr_accessor :bad
  attr_accessor :good
  attr_accessor :current_user_attempts

  def total_attempts user
    @current_user_attempts ||= self.attempts.where(:user_id => user.id)
    @total ||= @current_user_attempts.size
  end
  
  def bad_attempts user
    @current_user_attempts ||= self.attempts.where(:user_id => user.id)
    @bad ||= @current_user_attempts.select{|item| !item.is_correct}.count
  end
  
  def good_attempts user
    @current_user_attempts ||= self.attempts.where(:user_id => user.id)
    @good ||= @current_user_attempts.select{|item| item.is_correct}.count
  end
  
  def bad_attempts_percent user
    if total_attempts(user) > 0
        bad_attempts(user)/(total_attempts(user).to_f)
    else
      0.0
    end
  end
  
  def good_attempts_percent user
    if total_attempts(user) > 0
        good_attempts(user)/(total_attempts(user).to_f)
    else
      0.0
    end
  end
  
  def self.get_random_word user
    words = Word.includes(:attempts => :user).all

    weights = words.map do |w|
                all_attempts = w.attempts.select{|item| item.user_id == user.id}

                # find modifier related to the frequency of word usage
                word_attempts = all_attempts.select{|item| item.word_id == w.id}

                freq = (word_attempts.count == 0 ? 30000 : 3.0/word_attempts.count)

                # find modifier related to the percentage of succesfull attempts
                word_good_attempts = word_attempts.select{|item| item.is_correct}
                word_good_attempts_percent = if word_good_attempts.count > 0
                                                word_good_attempts.count/(word_attempts.count.to_f)
                                             else
                                                0.0
                                             end

                corr = (word_good_attempts_percent == 0.0 ? 10000 : 10.0/word_good_attempts_percent)
                          
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
  
  def average_leven(period, user)
    attempts = self.attempts.where(:user_id => user.id).all(:select => 'distance', :conditions => ['created_at > ?', period.ago])
    
    if attempts.empty?
      0
    else
      (attempts.inject(0){|sum, item| sum + item.distance})/attempts.size.to_f
    end
  end
  
  def self.average_leven(period, user)
    attempts = Attempt.where(:user_id => user.id).all(:select => 'distance', :conditions => ['created_at > ?', period.ago])
    
    if attempts.empty?
      0
    else
      (attempts.inject(0){|sum, item| sum + item.distance})/attempts.size.to_f
    end
  end
end

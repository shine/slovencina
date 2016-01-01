class StatisticsController < ApplicationController
  def index
    @words = Word.includes(:attempts).all.sort_by{|item| item.good_attempts_percent(current_user)}
    @total_attempts = current_user.attempts.count
    @total_good_attempts = current_user.attempts.count(:conditions => {:is_correct => true})
    @total_good_attempts_percent = @total_good_attempts/(@total_attempts.to_f)
  end
  
  def show
    days_counter = params[:id].to_i || 1
    attempts = current_user.attempts.where('created_at > ?', days_counter.days.ago)
    
    @stats = {}
    attempts.each do |a|
      unless @stats[a.word_id]
            word_attempts = attempts.select{|item| item.word_id == a.word_id}
            
            bad_attempts = word_attempts.select{|item| !item.is_correct}.size
            good_attempts = word_attempts.select{|item| item.is_correct}.size
            good_attempts_percent = good_attempts/(good_attempts + bad_attempts).to_f
            leven_avg = word_attempts.inject(0){|sum, item| sum += item.distance}.to_f/word_attempts.size
            
       @stats[a.word_id] = [good_attempts_percent, leven_avg]
      end
    end

    @stats.delete_if{|item| item[1][0] == 1.0}    
      stat_keys = @stats.keys
    @stats = @stats.sort_by{|item| (1/(item[1][0].to_f + 0.01))*item[1][1].to_f}.reverse
    @words = Word.where(:id => stat_keys)
  end
end

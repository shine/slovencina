class AddWordIdIndexToAttempts < ActiveRecord::Migration
  def self.up
    add_index :attempts, [:is_correct, :word_id]
    add_index :attempts, :word_id
  end

  def self.down
    remove_index :attempts, [:is_correct, :word_id]
    remove_index :attempts, :word_id
  end
end

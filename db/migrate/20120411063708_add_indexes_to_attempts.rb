class AddIndexesToAttempts < ActiveRecord::Migration
  def change
    add_index :attempts, [:user_id]
    add_index :attempts, [:word_id, :user_id]
  end
end

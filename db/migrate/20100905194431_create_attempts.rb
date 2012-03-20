class CreateAttempts < ActiveRecord::Migration
  def self.up
    create_table :attempts do |t|
      t.integer :word_id
      t.boolean :is_correct

      t.timestamps
    end
  end

  def self.down
    drop_table :attempts
  end
end

class AddLanguagesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :language_from, :string
    add_column :users, :language_to, :string

    add_index :users, [:language_from]
    add_index :users, [:language_to]
    add_index :users, [:language_from, :language_to]
  end
end
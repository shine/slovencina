desc "Imports a CSV file into an ActiveRecord table"
task :import => :environment do
  lines = File.new(File.join(Rails.root, 'doc', 'import.txt')).readlines
  lines.each do |line|
    params = {}
    values = line.strip.split('|||')
    Word.create! :rus => values[0], :slov => values[1], :category_id => 21
  end
end
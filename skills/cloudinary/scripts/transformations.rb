# List named transformations
# Usage: ruby scripts/transformations.rb

require_relative 'auth'

data = cloudinary_request(:get, '/transformations')

(data['transformations'] || []).each do |t|
  name    = t['name'] || '-'
  used    = t['used'] ? 'yes' : 'no'
  named   = t['named'] ? 'named' : 'derived'
  puts "#{name}\t#{named}\t#{used}"
end

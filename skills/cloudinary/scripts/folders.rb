# List root folders
# Usage: ruby scripts/folders.rb

require_relative 'auth'

data = cloudinary_request(:get, '/folders')

(data['folders'] || []).each do |f|
  puts "#{f['name']}\t#{f['path']}"
end

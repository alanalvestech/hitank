# List subfolders of a folder
# Usage: ruby scripts/subfolders.rb FOLDER

require_relative 'auth'

folder = ARGV[0] or abort("Usage: ruby #{__FILE__} FOLDER")

data = cloudinary_request(:get, "/folders/#{URI.encode_www_form_component(folder)}")

(data['folders'] || []).each do |f|
  puts "#{f['name']}\t#{f['path']}"
end

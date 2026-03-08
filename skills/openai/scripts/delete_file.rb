# Delete an OpenAI file
# Usage: ruby scripts/delete_file.rb FILE_ID

require_relative 'auth'

file_id = ARGV[0] or abort("Usage: ruby #{__FILE__} FILE_ID")

data = openai_request(:delete, "/files/#{file_id}")

if data && data['deleted']
  puts "Deleted file #{file_id}"
else
  abort "Failed to delete file #{file_id}: #{data.inspect}"
end

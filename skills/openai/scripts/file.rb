# Get details for an OpenAI file
# Usage: ruby scripts/file.rb FILE_ID

require_relative 'auth'

file_id = ARGV[0] or abort("Usage: ruby #{__FILE__} FILE_ID")

data = openai_request(:get, "/files/#{file_id}")

filename = data['filename'] || '-'
purpose  = data['purpose'] || '-'
bytes    = data['bytes'] || 0
status   = data['status'] || '-'
created  = data['created_at'] ? Time.at(data['created_at']).strftime('%Y-%m-%d %H:%M:%S') : '-'

puts "id:\t#{data['id']}"
puts "filename:\t#{filename}"
puts "purpose:\t#{purpose}"
puts "bytes:\t#{bytes}"
puts "status:\t#{status}"
puts "created_at:\t#{created}"

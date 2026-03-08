# List uploaded OpenAI files
# Usage: ruby scripts/files.rb

require_relative 'auth'

data = openai_request(:get, '/files')

files = data['data'] || []
files.each do |f|
  purpose  = f['purpose'] || '-'
  bytes    = f['bytes'] || 0
  created  = f['created_at'] ? Time.at(f['created_at']).strftime('%Y-%m-%d') : '-'
  filename = f['filename'] || '-'
  puts "#{f['id']}\t#{filename}\t#{purpose}\t#{bytes}\t#{created}"
end

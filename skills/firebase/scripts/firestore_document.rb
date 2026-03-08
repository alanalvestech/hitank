# Get a single Firestore document
# Usage: ruby scripts/firestore_document.rb PROJECT_ID COLLECTION DOC_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID COLLECTION DOC_ID")
collection = ARGV[1] or abort("Usage: ruby #{__FILE__} PROJECT_ID COLLECTION DOC_ID")
doc_id     = ARGV[2] or abort("Usage: ruby #{__FILE__} PROJECT_ID COLLECTION DOC_ID")

data = firebase_request(
  :get,
  "/v1/projects/#{project_id}/databases/(default)/documents/#{collection}/#{doc_id}",
  base_url: 'https://firestore.googleapis.com'
)

if data.nil?
  puts "Document not found."
  exit 1
end

if data['error']
  abort "Error: #{data['error']['message']} (code #{data['error']['code']})"
end

puts "Document: #{data['name']}"
puts "Created:  #{data['createTime'] || '-'}"
puts "Updated:  #{data['updateTime'] || '-'}"
puts ""

if data['fields'] && !data['fields'].empty?
  puts "Fields:"
  data['fields'].each do |key, value|
    # Firestore returns typed values like { "stringValue": "hello" }
    type = value.keys.first
    val  = value[type]
    puts "  #{key} (#{type}): #{val.is_a?(Hash) || val.is_a?(Array) ? JSON.generate(val) : val}"
  end
else
  puts "No fields."
end

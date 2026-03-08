# List documents in a Firestore collection
# Usage: ruby scripts/firestore_documents.rb PROJECT_ID COLLECTION

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID COLLECTION")
collection = ARGV[1] or abort("Usage: ruby #{__FILE__} PROJECT_ID COLLECTION")

data = firebase_request(
  :get,
  "/v1/projects/#{project_id}/databases/(default)/documents/#{collection}",
  base_url: 'https://firestore.googleapis.com'
)

if data.nil? || data['documents'].nil? || data['documents'].empty?
  puts "No documents found in collection '#{collection}'."
  exit 0
end

data['documents'].each do |doc|
  doc_id = doc['name'].split('/').last
  created = doc['createTime'] || '-'
  updated = doc['updateTime'] || '-'
  fields  = (doc['fields'] || {}).keys.join(', ')
  puts "#{doc_id}\tcreated=#{created}\tupdated=#{updated}\tfields=[#{fields}]"
end

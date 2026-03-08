# List top-level Firestore collections (documents at root)
# Usage: ruby scripts/firestore_collections.rb PROJECT_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

data = firebase_request(
  :get,
  "/v1/projects/#{project_id}/databases/(default)/documents",
  base_url: 'https://firestore.googleapis.com'
)

if data.nil? || data['documents'].nil? || data['documents'].empty?
  puts "No documents found at the root level."
  exit 0
end

# Extract collection names from document paths
collections = data['documents'].map { |doc|
  parts = doc['name'].split('/')
  # path: projects/PROJECT/databases/(default)/documents/COLLECTION/DOC_ID
  idx = parts.index('documents')
  parts[idx + 1] if idx
}.compact.uniq.sort

collections.each { |c| puts c }

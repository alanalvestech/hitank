# List annotations for a PostHog project
# Usage: ruby scripts/annotations.rb PROJECT_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

data = posthog_request(:get, "/api/projects/#{project_id}/annotations/")

results = data['results'] || data

results.each do |annotation|
  content    = annotation['content'] || '-'
  scope      = annotation['scope'] || '-'
  date_marker = annotation['date_marker'] || '-'
  created_by = annotation.dig('created_by', 'email') || annotation.dig('created_by', 'first_name') || '-'
  puts "#{annotation['id']}\t#{content}\t#{scope}\t#{date_marker}\t#{created_by}"
end

# List feature flags for a PostHog project
# Usage: ruby scripts/feature_flags.rb PROJECT_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

data = posthog_request(:get, "/api/projects/#{project_id}/feature_flags/")

results = data['results'] || data

results.each do |flag|
  name   = flag['name'] || '-'
  key    = flag['key'] || '-'
  active = flag['active'] ? 'active' : 'inactive'
  puts "#{flag['id']}\t#{key}\t#{name}\t#{active}"
end

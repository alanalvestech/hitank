# Get feature flag details for a PostHog project
# Usage: ruby scripts/feature_flag.rb PROJECT_ID FLAG_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID FLAG_ID")
flag_id    = ARGV[1] or abort("Missing FLAG_ID")

data = posthog_request(:get, "/api/projects/#{project_id}/feature_flags/#{flag_id}/")

puts "id=#{data['id']}"
puts "key=#{data['key']}"
puts "name=#{data['name']}"
puts "active=#{data['active']}"
puts "created_at=#{data['created_at']}"
puts "created_by=#{data.dig('created_by', 'email') || data.dig('created_by', 'first_name') || '-'}"
puts "rollout_percentage=#{data.dig('filters', 'groups', 0, 'rollout_percentage') || '-'}"
puts "ensure_experience_continuity=#{data['ensure_experience_continuity']}"

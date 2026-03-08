# List recent events for a PostHog project
# Usage: ruby scripts/events.rb PROJECT_ID [--event EVENT_NAME]

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID [--event EVENT_NAME]")

event_name = nil
if ARGV.include?('--event')
  idx = ARGV.index('--event')
  event_name = ARGV[idx + 1] or abort("Missing event name after --event")
end

path = "/api/projects/#{project_id}/events/"
path += "?event=#{URI.encode_www_form_component(event_name)}" if event_name

data = posthog_request(:get, path)

results = data['results'] || data

results.each do |event|
  name      = event['event'] || '-'
  person    = event.dig('person', 'distinct_ids')&.first || event['distinct_id'] || '-'
  timestamp = event['timestamp'] || '-'
  url       = event.dig('properties', '$current_url') || '-'
  puts "#{name}\t#{person}\t#{timestamp}\t#{url}"
end

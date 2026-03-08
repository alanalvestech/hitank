# List events for a Sentry issue
# Usage: ruby scripts/events.rb ISSUE_ID

require_relative 'auth'

issue_id = ARGV[0] or abort("Usage: ruby #{__FILE__} ISSUE_ID")

data = sentry_request(:get, "/issues/#{issue_id}/events/")

data.each do |event|
  id        = event['eventID'] || event['id'] || '-'
  title     = event['title'] || '-'
  timestamp = event['dateCreated'] || '-'
  tags      = (event['tags'] || []).map { |t| "#{t['key']}:#{t['value']}" }.join(', ')
  puts "#{id}\t#{title}\t#{timestamp}\t#{tags}"
end

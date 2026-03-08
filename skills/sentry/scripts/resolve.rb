# Resolve a Sentry issue
# Usage: ruby scripts/resolve.rb ISSUE_ID

require_relative 'auth'

issue_id = ARGV[0] or abort("Usage: ruby #{__FILE__} ISSUE_ID")

data = sentry_request(:put, "/issues/#{issue_id}/", body: { "status" => "resolved" })

puts "Issue #{issue_id} resolved"
puts "title=#{data['title']}" if data && data['title']
puts "status=#{data['status']}" if data && data['status']

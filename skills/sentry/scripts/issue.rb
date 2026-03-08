# Get Sentry issue details
# Usage: ruby scripts/issue.rb ISSUE_ID

require_relative 'auth'

issue_id = ARGV[0] or abort("Usage: ruby #{__FILE__} ISSUE_ID")

data = sentry_request(:get, "/issues/#{issue_id}/")

puts "id=#{data['id']}"
puts "title=#{data['title']}"
puts "culprit=#{data['culprit']}"
puts "level=#{data['level']}"
puts "status=#{data['status']}"
puts "platform=#{data['platform']}"
puts "count=#{data['count']}"
puts "userCount=#{data['userCount']}"
puts "firstSeen=#{data['firstSeen']}"
puts "lastSeen=#{data['lastSeen']}"
puts "permalink=#{data['permalink']}"

if data['assignedTo']
  puts "assignedTo=#{data.dig('assignedTo', 'name') || data.dig('assignedTo', 'email') || '-'}"
end

if data['metadata']
  puts "type=#{data.dig('metadata', 'type') || '-'}"
  puts "value=#{data.dig('metadata', 'value') || '-'}"
end

# List issues for a Sentry project
# Usage: ruby scripts/issues.rb ORG PROJECT [--query QUERY]

require_relative 'auth'

org     = ARGV[0] or abort("Usage: ruby #{__FILE__} ORG PROJECT [--query QUERY]")
project = ARGV[1] or abort("Usage: ruby #{__FILE__} ORG PROJECT [--query QUERY]")

query = nil
if ARGV[2] == '--query' && ARGV[3]
  query = ARGV[3]
end

path = "/projects/#{org}/#{project}/issues/"
path += "?query=#{URI.encode_www_form_component(query)}" if query

data = sentry_request(:get, path)

data.each do |issue|
  id        = issue['id'] || '-'
  title     = issue['title'] || '-'
  level     = issue['level'] || '-'
  status    = issue['status'] || '-'
  count     = issue['count'] || '-'
  last_seen = issue['lastSeen'] || '-'
  puts "#{id}\t#{title}\t#{level}\t#{status}\t#{count}\t#{last_seen}"
end

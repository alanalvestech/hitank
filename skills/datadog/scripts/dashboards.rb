# List Datadog dashboards
# Usage: ruby scripts/dashboards.rb

require_relative 'auth'

data = dd_request(:get, '/dashboard')

dashboards = data['dashboards'] || []
dashboards.each do |d|
  title    = d['title'] || '-'
  layout   = d['layout_type'] || '-'
  created  = d['created_at'] || '-'
  modified = d['modified_at'] || '-'
  puts "#{d['id']}\t#{title}\t#{layout}\t#{created}\t#{modified}"
end

# List Firebase projects
# Usage: ruby scripts/projects.rb

require_relative 'auth'

data = firebase_request(:get, '/v1beta1/projects')

if data.nil? || data['results'].nil? || data['results'].empty?
  puts "No Firebase projects found."
  exit 0
end

data['results'].each do |project|
  id      = project['projectId'] || '-'
  name    = project['displayName'] || '-'
  state   = project['state'] || '-'
  puts "#{id}\t#{name}\t#{state}"
end

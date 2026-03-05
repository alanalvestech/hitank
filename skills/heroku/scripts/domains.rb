# List domains for a Heroku app
# Usage: ruby scripts/domains.rb APP

require_relative 'auth'

app = ARGV[0] or abort("Usage: ruby #{__FILE__} APP")

data = heroku_request(:get, "/apps/#{app}/domains")

data.each do |d|
  hostname = d['hostname'] || '-'
  kind     = d['kind'] || '-'
  cname    = d['cname'] || '-'
  status   = d['status'] || '-'
  puts "#{hostname}\t#{kind}\t#{cname}\t#{status}"
end

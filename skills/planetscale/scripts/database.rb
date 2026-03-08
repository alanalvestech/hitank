# Get details for a PlanetScale database
# Usage: ruby scripts/database.rb ORG DATABASE

require_relative 'auth'

org  = ARGV[0] or abort("Usage: ruby #{__FILE__} ORG DATABASE")
name = ARGV[1] or abort("Usage: ruby #{__FILE__} ORG DATABASE")

data = ps_request(:get, "/organizations/#{org}/databases/#{name}")

region  = data['region'] || data.dig('region', 'slug') || '-'
state   = data['state'] || '-'
plan    = data['plan'] || '-'
created = data['created_at'] || '-'
updated = data['updated_at'] || '-'
url     = data['html_url'] || '-'

puts "name:\t#{data['name']}"
puts "region:\t#{region}"
puts "state:\t#{state}"
puts "plan:\t#{plan}"
puts "created_at:\t#{created}"
puts "updated_at:\t#{updated}"
puts "url:\t#{url}"

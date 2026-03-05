# List releases for a Heroku app
# Usage: ruby scripts/releases.rb APP

require_relative 'auth'

app = ARGV[0] or abort("Usage: ruby #{__FILE__} APP")

data = heroku_request(:get, "/apps/#{app}/releases")

data.each do |r|
  version = r['version'] || '-'
  desc    = r['description'] || '-'
  user    = r.dig('user', 'email') || '-'
  status  = r['status'] || '-'
  created = r['created_at'] || '-'
  puts "v#{version}\t#{desc}\t#{user}\t#{status}\t#{created}"
end

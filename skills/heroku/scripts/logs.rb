# Create a log session for a Heroku app
# Usage: ruby scripts/logs.rb APP [--lines N]

require_relative 'auth'

app = ARGV[0] or abort("Usage: ruby #{__FILE__} APP [--lines N]")

lines = 100
if (idx = ARGV.index('--lines')) && ARGV[idx + 1]
  lines = ARGV[idx + 1].to_i
end

data = heroku_request(:post, "/apps/#{app}/log-sessions", body: { lines: lines, tail: false })

puts data['logplex_url']

# List active Datadog metrics
# Usage: ruby scripts/metrics.rb [--host HOSTNAME]

require_relative 'auth'

from = Time.now.to_i - 3600

params = { from: from }
if idx = ARGV.index('--host')
  params[:host] = ARGV[idx + 1]
end

data = dd_request(:get, '/metrics', params: params)

metrics = data['metrics'] || []
metrics.each do |m|
  puts m
end

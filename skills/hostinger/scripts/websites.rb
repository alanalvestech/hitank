# List websites
# Usage: ruby scripts/websites.rb [--page N]

require_relative 'auth'

params = {}
if (idx = ARGV.index('--page')) && ARGV[idx + 1]
  params['page'] = ARGV[idx + 1]
end

data = hostinger_request(:get, '/api/hosting/v1/websites', params: params)

((data.is_a?(Hash) ? data['data'] : data) || []).each do |w|
  domain  = w['domain'] || '-'
  enabled = w['is_enabled'] ? 'active' : 'disabled'
  puts "#{domain}\t#{enabled}\t#{w['username'] || '-'}"
end

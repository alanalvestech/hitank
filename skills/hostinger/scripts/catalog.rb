# List catalog items available for order
# Usage: ruby scripts/catalog.rb [--category CATEGORY]

require_relative 'auth'

params = {}
if (idx = ARGV.index('--category')) && ARGV[idx + 1]
  params['category'] = ARGV[idx + 1]
end

data = hostinger_request(:get, '/api/billing/v1/catalog', params: params)

(data || []).each do |c|
  name     = c['name'] || '-'
  category = c['category'] || '-'
  price    = c['price'] ? "$#{c['price']}" : '-'
  puts "#{c['id']}\t#{category}\t#{name}\t#{price}"
end

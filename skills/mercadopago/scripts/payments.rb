# List/search payments
# Usage: ruby scripts/payments.rb [--status STATUS]

require_relative 'auth'

status = nil

i = 0
while i < ARGV.length
  case ARGV[i]
  when '--status'
    status = ARGV[i + 1]
    i += 2
  else
    i += 1
  end
end

path = '/v1/payments/search'
params = []
params << "status=#{status}" if status
path += "?#{params.join('&')}" unless params.empty?

data = mp_request(:get, path)

results = data['results'] || []

if results.empty?
  puts "No payments found"
  exit 0
end

results.each do |p|
  id          = p['id'] || '-'
  st          = p['status'] || '-'
  amount      = p['transaction_amount'] || '-'
  currency    = p['currency_id'] || '-'
  description = p['description'] || '-'
  date        = p['date_created'] || '-'
  puts "#{id}\t#{st}\t#{amount}\t#{currency}\t#{description}\t#{date}"
end

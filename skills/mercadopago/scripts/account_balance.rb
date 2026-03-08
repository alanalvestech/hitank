# Check account balance
# Usage: ruby scripts/account_balance.rb

require_relative 'auth'

data = mp_request(:get, '/v1/account/balance')

if data['error']
  abort "Error: #{data['message']} (#{data['error']})"
end

puts "available_balance:\t#{data['available_balance']}"
puts "total_amount:\t#{data['total_amount']}"
puts "currency_id:\t#{data['currency_id'] || '-'}"

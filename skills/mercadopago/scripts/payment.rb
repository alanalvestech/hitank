# Get payment details by ID
# Usage: ruby scripts/payment.rb PAYMENT_ID

require_relative 'auth'

payment_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PAYMENT_ID")

data = mp_request(:get, "/v1/payments/#{payment_id}")

puts "id:\t#{data['id']}"
puts "status:\t#{data['status']}"
puts "status_detail:\t#{data['status_detail']}"
puts "transaction_amount:\t#{data['transaction_amount']}"
puts "currency_id:\t#{data['currency_id']}"
puts "description:\t#{data['description'] || '-'}"
puts "payment_method_id:\t#{data['payment_method_id'] || '-'}"
puts "payment_type_id:\t#{data['payment_type_id'] || '-'}"
puts "payer_email:\t#{data.dig('payer', 'email') || '-'}"
puts "payer_id:\t#{data.dig('payer', 'id') || '-'}"
puts "date_created:\t#{data['date_created'] || '-'}"
puts "date_approved:\t#{data['date_approved'] || '-'}"
puts "external_reference:\t#{data['external_reference'] || '-'}"

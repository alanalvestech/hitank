# Get customer details by ID
# Usage: ruby scripts/customer.rb CUSTOMER_ID

require_relative 'auth'

customer_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CUSTOMER_ID")

data = mp_request(:get, "/v1/customers/#{customer_id}")

puts "id:\t#{data['id']}"
puts "email:\t#{data['email'] || '-'}"
puts "first_name:\t#{data['first_name'] || '-'}"
puts "last_name:\t#{data['last_name'] || '-'}"
puts "phone:\t#{data.dig('phone', 'number') || '-'}"
puts "identification_type:\t#{data.dig('identification', 'type') || '-'}"
puts "identification_number:\t#{data.dig('identification', 'number') || '-'}"
puts "date_created:\t#{data['date_created'] || '-'}"
puts "default_address:\t#{data['default_address'] || '-'}"

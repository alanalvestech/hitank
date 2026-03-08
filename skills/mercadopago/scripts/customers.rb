# List/search customers
# Usage: ruby scripts/customers.rb [--email EMAIL]

require_relative 'auth'

email = nil

i = 0
while i < ARGV.length
  case ARGV[i]
  when '--email'
    email = ARGV[i + 1]
    i += 2
  else
    i += 1
  end
end

path = '/v1/customers/search'
params = []
params << "email=#{email}" if email
path += "?#{params.join('&')}" unless params.empty?

data = mp_request(:get, path)

results = data['results'] || []

if results.empty?
  puts "No customers found"
  exit 0
end

results.each do |c|
  id    = c['id'] || '-'
  email = c['email'] || '-'
  name  = [c['first_name'], c['last_name']].compact.join(' ')
  name  = '-' if name.empty?
  date  = c['date_created'] || '-'
  puts "#{id}\t#{email}\t#{name}\t#{date}"
end

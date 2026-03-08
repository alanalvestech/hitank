# List or search Intercom contacts
# Usage: ruby scripts/contacts.rb
# Usage: ruby scripts/contacts.rb --email user@example.com

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

if email
  # Search contacts by email
  payload = {
    query: {
      field:    'email',
      operator: '=',
      value:    email
    }
  }
  data = intercom_request(:post, '/contacts/search', body: payload)
else
  data = intercom_request(:get, '/contacts')
end

contacts = data['data'] || []
contacts.each do |contact|
  name  = contact['name'] || '-'
  email = contact['email'] || '-'
  role  = contact['role'] || '-'
  puts "#{contact['id']}\t#{name}\t#{email}\t#{role}"
end

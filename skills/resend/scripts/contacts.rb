# List contacts
# Usage: ruby scripts/contacts.rb

require_relative 'auth'

data = resend_request(:get, '/contacts')

(data['data'] || []).each do |c|
  name = [c['first_name'], c['last_name']].compact.join(' ')
  name = '-' if name.empty?
  unsub = c['unsubscribed'] ? 'unsubscribed' : 'subscribed'
  puts "#{c['id']}\t#{c['email'] || '-'}\t#{name}\t#{unsub}"
end

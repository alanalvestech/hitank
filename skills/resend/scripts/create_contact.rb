# Create a contact
# Usage: ruby scripts/create_contact.rb EMAIL [--first-name NAME] [--last-name NAME]

require_relative 'auth'

email = ARGV[0] or abort("Usage: ruby #{__FILE__} EMAIL [--first-name NAME] [--last-name NAME]")

body = { 'email' => email }

if (idx = ARGV.index('--first-name')) && ARGV[idx + 1]
  body['first_name'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--last-name')) && ARGV[idx + 1]
  body['last_name'] = ARGV[idx + 1]
end

data = resend_request(:post, '/contacts', body: body)

puts "Created contact: #{data['id']}"

# Delete a contact
# Usage: ruby scripts/delete_contact.rb CONTACT_ID

require_relative 'auth'

contact_id = ARGV[0] or abort("Usage: ruby #{__FILE__} CONTACT_ID")

resend_request(:delete, "/contacts/#{contact_id}")

puts "Deleted contact: #{contact_id}"

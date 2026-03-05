# Get email details
# Usage: ruby scripts/email.rb EMAIL_ID

require_relative 'auth'

email_id = ARGV[0] or abort("Usage: ruby #{__FILE__} EMAIL_ID")

data = resend_request(:get, "/emails/#{email_id}")

puts "id:\t#{data['id'] || '-'}"
puts "from:\t#{data['from'] || '-'}"
puts "to:\t#{(data['to'] || []).join(', ')}"
puts "subject:\t#{data['subject'] || '-'}"
puts "status:\t#{data['last_event'] || '-'}"
puts "created:\t#{data['created_at'] || '-'}"
puts "scheduled:\t#{data['scheduled_at'] || '-'}" if data['scheduled_at']

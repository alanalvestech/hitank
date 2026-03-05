# Cancel a scheduled email
# Usage: ruby scripts/cancel_email.rb EMAIL_ID

require_relative 'auth'

email_id = ARGV[0] or abort("Usage: ruby #{__FILE__} EMAIL_ID")

resend_request(:delete, "/emails/#{email_id}")

puts "Cancelled email: #{email_id}"

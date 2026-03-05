# Send an email
# Usage: ruby scripts/send_email.rb FROM TO SUBJECT [--html HTML] [--text TEXT] [--cc CC] [--bcc BCC] [--reply-to REPLY_TO]
# Example: ruby scripts/send_email.rb "Me <me@example.com>" "user@example.com" "Hello" --html "<h1>Hi!</h1>"
# Example: ruby scripts/send_email.rb "me@example.com" "user@example.com" "Hello" --text "Hi there"

require_relative 'auth'

from    = ARGV[0] or abort("Usage: ruby #{__FILE__} FROM TO SUBJECT [--html HTML] [--text TEXT] [--cc CC] [--bcc BCC] [--reply-to REPLY_TO]")
to      = ARGV[1] or abort("Missing TO")
subject = ARGV[2] or abort("Missing SUBJECT")

body = { 'from' => from, 'to' => [to], 'subject' => subject }

if (idx = ARGV.index('--html')) && ARGV[idx + 1]
  body['html'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--text')) && ARGV[idx + 1]
  body['text'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--cc')) && ARGV[idx + 1]
  body['cc'] = [ARGV[idx + 1]]
end
if (idx = ARGV.index('--bcc')) && ARGV[idx + 1]
  body['bcc'] = [ARGV[idx + 1]]
end
if (idx = ARGV.index('--reply-to')) && ARGV[idx + 1]
  body['reply_to'] = [ARGV[idx + 1]]
end

# Default to text if neither html nor text provided
body['text'] = subject unless body['html'] || body['text']

data = resend_request(:post, '/emails', body: body)

if data && data['id']
  puts "id:\t#{data['id']}"
else
  puts data.inspect
end

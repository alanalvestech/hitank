# Create a broadcast
# Usage: ruby scripts/create_broadcast.rb SEGMENT_ID FROM SUBJECT [--html HTML] [--text TEXT] [--name NAME] [--send]
# Example: ruby scripts/create_broadcast.rb seg_123 "Me <me@example.com>" "Newsletter" --html "<h1>News</h1>" --send

require_relative 'auth'

segment_id = ARGV[0] or abort("Usage: ruby #{__FILE__} SEGMENT_ID FROM SUBJECT [--html HTML] [--text TEXT] [--name NAME] [--send]")
from       = ARGV[1] or abort("Missing FROM")
subject    = ARGV[2] or abort("Missing SUBJECT")

body = {
  'segment_id' => segment_id,
  'from' => from,
  'subject' => subject
}

if (idx = ARGV.index('--html')) && ARGV[idx + 1]
  body['html'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--text')) && ARGV[idx + 1]
  body['text'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--name')) && ARGV[idx + 1]
  body['name'] = ARGV[idx + 1]
end
if ARGV.include?('--send')
  body['send'] = true
end

body['text'] = subject unless body['html'] || body['text']

data = resend_request(:post, '/broadcasts', body: body)

puts "id:\t#{data['id']}"
puts "status:\t#{ARGV.include?('--send') ? 'sending' : 'draft'}"

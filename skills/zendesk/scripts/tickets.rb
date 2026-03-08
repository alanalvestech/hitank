# List Zendesk tickets
# Usage: ruby scripts/tickets.rb [--status STATUS]

require_relative 'auth'

status = nil
if ARGV.include?('--status')
  idx = ARGV.index('--status')
  status = ARGV[idx + 1]
end

path = '/tickets'
path += "?status=#{status}" if status

data = zendesk_request(:get, path)
tickets = data['tickets'] || []

if tickets.empty?
  puts "No tickets found."
  exit 0
end

tickets.each do |t|
  assignee = t['assignee_id'] || '-'
  puts "##{t['id']}\t#{t['status']}\t#{t['priority'] || '-'}\t#{assignee}\t#{t['subject']}"
end

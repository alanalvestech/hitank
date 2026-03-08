# List Workers scripts for a Cloudflare account
# Usage: ruby scripts/workers.rb ACCOUNT_ID

require_relative 'auth'

account_id = ARGV[0] or abort("Usage: ruby #{__FILE__} ACCOUNT_ID")

data = cf_request(:get, "/accounts/#{account_id}/workers/scripts")

unless data['success']
  abort "Error: #{(data['errors'] || []).map { |e| e['message'] }.join(', ')}"
end

data['result'].each do |script|
  modified = script['modified_on'] || '-'
  puts "#{script['id']}\t#{modified}"
end

# List API keys for a Supabase project
# Usage: ruby scripts/api_keys.rb PROJECT_REF

require_relative 'auth'

ref = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_REF")

data = supabase_request(:get, "/projects/#{ref}/api-keys")

if data.nil? || data.empty?
  puts "No API keys found"
  exit 0
end

data.each do |key|
  name = key['name'] || '-'
  api_key = key['api_key'] || '-'
  puts "#{name}\t#{api_key}"
end

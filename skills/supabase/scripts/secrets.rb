# List secrets for a Supabase project (masked)
# Usage: ruby scripts/secrets.rb PROJECT_REF

require_relative 'auth'

ref = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_REF")

data = supabase_request(:get, "/projects/#{ref}/secrets")

if data.nil? || data.empty?
  puts "No secrets found"
  exit 0
end

data.each do |secret|
  name  = secret['name'] || '-'
  value = secret['value'] || '****'
  # Mask the value — only show first 4 chars if long enough
  masked = value.length > 4 ? value[0..3] + '****' : '****'
  puts "#{name}=#{masked}"
end

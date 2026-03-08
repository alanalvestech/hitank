# List edge functions for a Supabase project
# Usage: ruby scripts/functions.rb PROJECT_REF

require_relative 'auth'

ref = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_REF")

data = supabase_request(:get, "/projects/#{ref}/functions")

if data.nil? || data.empty?
  puts "No edge functions found"
  exit 0
end

data.each do |fn|
  status  = fn['status'] || '-'
  version = fn['version'] || '-'
  created = fn['created_at'] || '-'
  puts "#{fn['slug']}\t#{fn['name']}\t#{status}\t#{version}\t#{created}"
end

# Get edge function details
# Usage: ruby scripts/function.rb PROJECT_REF FUNCTION_SLUG

require_relative 'auth'

ref  = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_REF FUNCTION_SLUG")
slug = ARGV[1] or abort("Usage: ruby #{__FILE__} PROJECT_REF FUNCTION_SLUG")

data = supabase_request(:get, "/projects/#{ref}/functions/#{slug}")

puts "slug:\t#{data['slug']}"
puts "name:\t#{data['name']}"
puts "status:\t#{data['status'] || '-'}"
puts "version:\t#{data['version'] || '-'}"
puts "verify_jwt:\t#{data['verify_jwt']}"
puts "created_at:\t#{data['created_at'] || '-'}"
puts "updated_at:\t#{data['updated_at'] || '-'}"

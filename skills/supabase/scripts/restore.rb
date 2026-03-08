# Restore a paused Supabase project
# Usage: ruby scripts/restore.rb PROJECT_REF

require_relative 'auth'

ref = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_REF")

supabase_request(:post, "/projects/#{ref}/restore")

puts "Project #{ref} restored"

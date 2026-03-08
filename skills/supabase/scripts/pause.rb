# Pause a Supabase project
# Usage: ruby scripts/pause.rb PROJECT_REF

require_relative 'auth'

ref = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_REF")

supabase_request(:post, "/projects/#{ref}/pause")

puts "Project #{ref} paused"

# Get account usage stats
# Usage: ruby scripts/usage.rb

require_relative 'auth'

data = cloudinary_request(:get, '/usage')

if data['error']
  abort "Error: #{data['error']['message']}"
end

puts "Plan:           #{data['plan']}"
puts "Last updated:   #{data['last_updated']}"

%w[transformations objects bandwidth storage requests].each do |key|
  section = data[key]
  next unless section.is_a?(Hash)
  used  = section['usage'] || 0
  limit = section['limit'] || 0
  pct   = section['used_percent'] || 0
  puts "#{key.ljust(16)}#{used} / #{limit} (#{pct}%)"
end

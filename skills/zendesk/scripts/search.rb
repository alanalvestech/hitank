# Search Zendesk (tickets, users, organizations)
# Usage: ruby scripts/search.rb 'QUERY'

require_relative 'auth'

query = ARGV[0] or abort("Usage: ruby #{__FILE__} QUERY")

encoded = URI.encode_www_form_component(query)
data = zendesk_request(:get, "/search.json?query=#{encoded}")
results = data['results'] || []

if results.empty?
  puts "No results found."
  exit 0
end

results.each do |r|
  type = r['result_type']
  case type
  when 'ticket'
    puts "ticket\t##{r['id']}\t#{r['status']}\t#{r['subject']}"
  when 'user'
    puts "user\t##{r['id']}\t#{r['name']}\t#{r['email']}"
  when 'organization'
    puts "org\t##{r['id']}\t#{r['name']}"
  else
    puts "#{type}\t##{r['id']}\t#{r['name'] || r['subject'] || '-'}"
  end
end

puts "\nTotal: #{data['count'] || results.length} results"

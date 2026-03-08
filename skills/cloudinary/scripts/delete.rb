# Delete a resource by public ID
# Usage: ruby scripts/delete.rb PUBLIC_ID

require_relative 'auth'

public_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PUBLIC_ID")

data = cloudinary_request(:delete, "/resources/image/upload?public_ids[]=#{URI.encode_www_form_component(public_id)}")

if data['error']
  abort "Error: #{data['error']['message']}"
end

deleted = data.dig('deleted', public_id)
if deleted == 'deleted'
  puts "Deleted: #{public_id}"
else
  puts "Result for #{public_id}: #{deleted || 'not_found'}"
end

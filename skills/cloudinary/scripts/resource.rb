# Get single image resource details
# Usage: ruby scripts/resource.rb PUBLIC_ID

require_relative 'auth'

public_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PUBLIC_ID")

data = cloudinary_request(:get, "/resources/image/upload/#{URI.encode_www_form_component(public_id)}")

if data['error']
  abort "Error: #{data['error']['message']}"
end

puts "public_id:    #{data['public_id']}"
puts "format:       #{data['format']}"
puts "resource_type:#{data['resource_type']}"
puts "type:         #{data['type']}"
puts "width:        #{data['width']}"
puts "height:       #{data['height']}"
puts "bytes:        #{data['bytes']}"
puts "url:          #{data['url']}"
puts "secure_url:   #{data['secure_url']}"
puts "created_at:   #{data['created_at']}"
puts "tags:         #{(data['tags'] || []).join(', ')}"
puts "folder:       #{data['folder']}"

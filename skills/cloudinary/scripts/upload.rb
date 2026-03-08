# Upload image from URL
# Usage: ruby scripts/upload.rb --url URL --public_id PUBLIC_ID

require_relative 'auth'

url       = nil
public_id = nil

i = 0
while i < ARGV.length
  case ARGV[i]
  when '--url'       then url       = ARGV[i + 1]; i += 2
  when '--public_id' then public_id = ARGV[i + 1]; i += 2
  else i += 1
  end
end

abort("Usage: ruby #{__FILE__} --url URL --public_id PUBLIC_ID") unless url

# Upload endpoint is at the top-level cloud path, not under /resources
uri = URI("#{BASE_URL}/image/upload")
req = Net::HTTP::Post.new(uri)
req.basic_auth(API_KEY, API_SECRET)
req.set_form_data({ 'file' => url, 'public_id' => public_id }.compact)

resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
data = JSON.parse(resp.body)

if data['error']
  abort "Error: #{data['error']['message']}"
end

puts "Uploaded: #{data['public_id']}"
puts "Format:   #{data['format']}"
puts "Size:     #{data['bytes']} bytes"
puts "URL:      #{data['secure_url']}"

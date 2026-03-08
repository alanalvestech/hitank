# Create a new DigitalOcean droplet
# Usage: ruby scripts/create_droplet.rb NAME REGION SIZE IMAGE
# Example: ruby scripts/create_droplet.rb my-server nyc1 s-1vcpu-1gb ubuntu-24-04-x64

require_relative 'auth'

name   = ARGV[0] or abort("Usage: ruby #{__FILE__} NAME REGION SIZE IMAGE")
region = ARGV[1] or abort("Usage: ruby #{__FILE__} NAME REGION SIZE IMAGE")
size   = ARGV[2] or abort("Usage: ruby #{__FILE__} NAME REGION SIZE IMAGE")
image  = ARGV[3] or abort("Usage: ruby #{__FILE__} NAME REGION SIZE IMAGE")

body = {
  name:   name,
  region: region,
  size:   size,
  image:  image
}

data = do_request(:post, '/droplets', body: body)
d = data['droplet']

puts "id:\t#{d['id']}"
puts "name:\t#{d['name']}"
puts "status:\t#{d['status']}"
puts "region:\t#{d.dig('region', 'slug') || region}"
puts "size:\t#{d.dig('size', 'slug') || size}"
puts "image:\t#{d.dig('image', 'slug') || d.dig('image', 'name') || image}"
puts "created_at:\t#{d['created_at'] || '-'}"

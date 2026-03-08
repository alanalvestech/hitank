# List image resources
# Usage: ruby scripts/resources.rb [--type upload|fetch] [--prefix FOLDER]

require_relative 'auth'

type   = nil
prefix = nil

i = 0
while i < ARGV.length
  case ARGV[i]
  when '--type'   then type   = ARGV[i + 1]; i += 2
  when '--prefix' then prefix = ARGV[i + 1]; i += 2
  else i += 1
  end
end

path = '/resources/image'
path += "/#{type}" if type

params = []
params << "prefix=#{URI.encode_www_form_component(prefix)}" if prefix
path += "?#{params.join('&')}" unless params.empty?

data = cloudinary_request(:get, path)

(data['resources'] || []).each do |r|
  pub_id  = r['public_id'] || '-'
  format  = r['format'] || '-'
  bytes   = r['bytes'] || 0
  created = r['created_at'] || '-'
  puts "#{pub_id}\t#{format}\t#{bytes}\t#{created}"
end

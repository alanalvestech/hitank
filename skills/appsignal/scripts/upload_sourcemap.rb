# Upload a sourcemap
# Usage: ruby scripts/upload_sourcemap.rb --push_api_key KEY --app_name NAME --environment ENV --revision REV --name URL --file PATH

require 'json'
require 'net/http'
require 'uri'

args = {}
%w[push_api_key app_name environment revision name file].each do |key|
  if (idx = ARGV.index("--#{key}")) && ARGV[idx + 1]
    args[key] = ARGV[idx + 1]
  end
end

%w[push_api_key app_name environment revision name file].each do |key|
  abort("--#{key} is required") unless args[key]
end

file_path = File.expand_path(args['file'])
abort("File not found: #{file_path}") unless File.exist?(file_path)

boundary = "----RubyBoundary#{rand(1_000_000)}"
uri = URI("https://appsignal.com/api/sourcemaps?push_api_key=#{URI.encode_www_form_component(args['push_api_key'])}&app_name=#{URI.encode_www_form_component(args['app_name'])}&environment=#{URI.encode_www_form_component(args['environment'])}")

body = []
body << "--#{boundary}\r\nContent-Disposition: form-data; name=\"revision\"\r\n\r\n#{args['revision']}"
body << "--#{boundary}\r\nContent-Disposition: form-data; name=\"name[]\"\r\n\r\n#{args['name']}"
body << "--#{boundary}\r\nContent-Disposition: form-data; name=\"file\"; filename=\"#{File.basename(file_path)}\"\r\nContent-Type: application/octet-stream\r\n\r\n#{File.binread(file_path)}"
body << "--#{boundary}--"

req = Net::HTTP::Post.new(uri)
req['Content-Type'] = "multipart/form-data; boundary=#{boundary}"
req.body = body.join("\r\n")

resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

if resp.code == '201'
  puts "Sourcemap uploaded successfully"
elsif resp.body && !resp.body.empty?
  data = JSON.parse(resp.body)
  abort "Error: #{data['errors']&.join(', ') || resp.body}"
else
  abort "Error: HTTP #{resp.code}"
end

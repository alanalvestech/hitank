# Save a service account JSON key file for Firebase
# Usage: ruby scripts/save_token.rb /path/to/service_account.json

require 'json'
require 'fileutils'

source_path = ARGV[0] or abort("Usage: ruby #{__FILE__} /path/to/service_account.json")
source_path = File.expand_path(source_path)

unless File.exist?(source_path)
  abort "File not found: #{source_path}"
end

# Validate the JSON structure
begin
  data = JSON.parse(File.read(source_path))
rescue JSON::ParserError => e
  abort "Invalid JSON: #{e.message}"
end

required_fields = %w[type project_id private_key client_email token_uri]
missing = required_fields.select { |f| data[f].nil? || data[f].to_s.empty? }

unless missing.empty?
  abort "Invalid service account JSON — missing fields: #{missing.join(', ')}"
end

unless data['type'] == 'service_account'
  abort "Invalid key file: expected type 'service_account', got '#{data['type']}'"
end

config_dir = File.expand_path('~/.config/firebase')
dest_file  = File.join(config_dir, 'service_account.json')

FileUtils.mkdir_p(config_dir)
FileUtils.cp(source_path, dest_file)
File.chmod(0600, dest_file)

puts "Service account key saved to #{dest_file}"
puts "Project: #{data['project_id']}"
puts "Client email: #{data['client_email']}"

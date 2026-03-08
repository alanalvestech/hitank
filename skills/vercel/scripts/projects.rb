# List all Vercel projects
# Usage: ruby scripts/projects.rb

require_relative 'auth'

data = vercel_request(:get, '/v9/projects')

(data['projects'] || []).each do |proj|
  framework  = proj['framework'] || '-'
  updated    = proj['updatedAt'] ? Time.at(proj['updatedAt'] / 1000).utc.strftime('%Y-%m-%dT%H:%M:%SZ') : '-'
  puts "#{proj['name']}\t#{proj['id']}\t#{framework}\t#{updated}"
end

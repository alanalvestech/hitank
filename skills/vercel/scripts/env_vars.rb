# List env vars for a Vercel project
# Usage: ruby scripts/env_vars.rb PROJECT_ID [--reveal]

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID [--reveal]")
reveal = ARGV.include?('--reveal')

path = "/v1/projects/#{project_id}/env"
path += '?decrypt=true' if reveal

data = vercel_request(:get, path)

(data['envs'] || []).each do |env|
  target = (env['target'] || []).join(',')
  if reveal
    puts "#{env['key']}=#{env['value']}\t#{target}"
  else
    puts "#{env['key']}=****\t#{target}"
  end
end

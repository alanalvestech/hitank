# List OpenAI fine-tuning jobs
# Usage: ruby scripts/fine_tuning_jobs.rb

require_relative 'auth'

data = openai_request(:get, '/fine_tuning/jobs')

jobs = data['data'] || []
if jobs.empty?
  puts "No fine-tuning jobs found"
  exit 0
end

jobs.each do |job|
  model      = job['model'] || '-'
  fine_tuned = job['fine_tuned_model'] || '-'
  status     = job['status'] || '-'
  created    = job['created_at'] ? Time.at(job['created_at']).strftime('%Y-%m-%d %H:%M:%S') : '-'
  puts "#{job['id']}\t#{model}\t#{fine_tuned}\t#{status}\t#{created}"
end

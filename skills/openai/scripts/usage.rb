# Get OpenAI usage stats (last 30 days)
# Usage: ruby scripts/usage.rb

require_relative 'auth'

start_time = (Time.now - (30 * 24 * 60 * 60)).to_i

data = openai_request(:get, "/organization/usage/completions?start_time=#{start_time}")

buckets = data['data'] || []
if buckets.empty?
  puts "No usage data in the last 30 days"
  exit 0
end

buckets.each do |bucket|
  results = bucket['results'] || []
  results.each do |r|
    input_tokens  = r['input_tokens'] || 0
    output_tokens = r['output_tokens'] || 0
    num_requests  = r['num_model_requests'] || 0
    puts "requests:#{num_requests}\tinput_tokens:#{input_tokens}\toutput_tokens:#{output_tokens}"
  end
end

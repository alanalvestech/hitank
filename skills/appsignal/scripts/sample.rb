# Get sample details
# Usage: ruby scripts/sample.rb APP_ID SAMPLE_ID

require_relative 'auth'

app_id    = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_ID SAMPLE_ID")
sample_id = ARGV[1] or abort("Usage: ruby #{__FILE__} APP_ID SAMPLE_ID")

data = appsignal_request(:get, "/#{app_id}/samples/#{sample_id}.json")

%w[id action path duration status time is_exception hostname kind request_method].each do |k|
  puts "#{k}\t#{data[k]}" if data[k]
end

if data['exception']
  exc = data['exception']
  puts "exception_name\t#{exc['name']}"
  puts "exception_message\t#{exc['message']}"
  puts "backtrace\t#{(exc['backtrace'] || []).first(5).join(' | ')}"
end

if data['events']
  puts "\nevents:"
  data['events'].each do |e|
    puts "  #{e['name']}\t#{e['duration'] || '-'}ms"
  end
end

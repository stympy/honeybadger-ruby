Given /^the following Rack app:$/ do |definition|
  File.open(RACK_FILE, 'w') { |file| file.write(definition) }
end

When /^I perform a Rack request to "([^\"]*)"$/ do |url|
  request_file = File.join(TEMP_DIR, 'rack_request.rb')
  File.open(request_file, 'w') do |file|
    file.puts "require 'rubygems'"
    file.puts IO.read(SHIM_FILE)
    file.puts IO.read(RACK_FILE)
    file.puts "env = Rack::MockRequest.env_for(#{url.inspect})"
    file.puts "status, headers, body = app.call(env)"
    file.puts %{puts "HTTP \#{status}"}
    file.puts %{headers.each { |key, value| puts "\#{key}: \#{value}"}}
    file.puts "body.each { |part| print part }"
  end
  step %(I run `ruby #{request_file}`)
end

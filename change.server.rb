#!/bin/ruby

require 'fileutils'

puts ""
puts "Insert common name to be used:"
common_name = gets

puts ""
puts "Insert server fqdn to be use:"
srv_fqdn = gets

answer = 'y'
if common_name != srv_fqdn
  puts ""
  puts "common name and the server fqdn do not match, is that OK? y/n"
  answer = gets.downcase
end

if answer.match?('n') || !answer.match?('y') 
  exit
else
#  file_name = '/var/ca-scripts/settings/server.cert.conf'
  file_name = 'settings/server.cert.conf'
  text = File.read(file_name)
  new_contents = text.gsub(/common_name:.*\R+/,"common_name: #{common_name}")
  new_contents = new_contents.gsub(/srv_fqdn:.*\R+/,"srv_fqdn: #{srv_fqdn}")
#  File.write('/var/ca-scripts/settings/server.cert.conf', new_contents)
  File.write('settings/server.cert.conf', new_contents)
end


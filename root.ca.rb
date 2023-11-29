#!/bin/ruby

require 'fileutils'

file = File.open("/var/ca-scripts/settings/root.ca.conf")
file_data = file.readlines.map(&:chomp)
file.close
settings={}
file_data.each do |setting|
  if setting.start_with?(/[a-z]/)
    array = setting.split(':') 
    settings[array[0].to_sym]=array[1]
  end
end

settings.each do |key, value|
  settings[key].strip!
end

opensslcnf = `cat /var/ca-scripts/openssl/openssl.cnf`

settings.each do |key, value|
  opensslcnf.gsub!("#{key.to_s.upcase}","#{value}")
end

FileUtils.mkdir_p("#{settings[:directory]}")
File.write("#{settings[:directory]}/openssl.cnf", opensslcnf)

script = `cat /var/ca-scripts/scripts/root-ca.sh`

settings.each do |key, value|
  script.gsub!("#{key.to_s.upcase}","#{value}")
end

File.write("#{settings[:directory]}/root-ca.sh", script)
`chmod +x #{settings[:directory]}/root-ca.sh`
`#{settings[:directory]}/root-ca.sh`

require 'spec_helper'
require 'json'

KEYS = %w{
  memory
  hostname
  domain
  fqdn
  platform
  platform_version
  filesystem
  cpu
  virtualization
  kernel
  block_device
  user
  group
}

host_inventory['cpu']
puts "{"

KEYS.each_with_index do |key, index|
  if index != KEYS.size - 1
    puts "\"#{key}\":" + host_inventory[key].to_json + ","
  elsif
    puts "\"#{key}\":" + host_inventory[key].to_json
  end
end

puts "}"

=begin
describe package('httpd'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe service('httpd'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe service('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

describe service('org.apache.httpd'), :if => os[:family] == 'darwin' do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end
=end

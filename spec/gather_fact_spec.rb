require 'spec_helper'
require 'json'
if host_inventory['platform'] == "redhat" && host_inventory['platform_version'].to_i < 7 then
  require './spec/chkconfig.rb'
elsif host_inventory['platform'] == "redhat" && host_inventory['platform_version'].to_i >= 7 then
  require './spec/systemctl.rb'
end

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

$stdout = File.open("nodes/#{ENV['TARGET_HOST']}/#{ENV['FACT_TIMING']}.json", "w")

fact = {}

KEYS.each do |key|
  fact.merge!( key => host_inventory[key] )
end

fact.merge!( 'service' => @service_fact )

puts JSON.pretty_generate(fact)

$stdout = STDOUT

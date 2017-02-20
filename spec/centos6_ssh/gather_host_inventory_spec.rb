require 'spec_helper'
require 'json'
require './spec/centos6_ssh/chkconfig.rb'

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


#puts host_inventory['cpu']

HOSTNAME = ARGV[1].split("/")[1]
FILENAME = File.exist?("spec/#{HOSTNAME}/before.json") ? "after.json" : "before.json"
puts "OUTPUT: " + FILENAME
$stdout = File.open("spec/#{HOSTNAME}/#{FILENAME}", "w")

fact = {}

KEYS.each do |key|
  fact.merge!( key => host_inventory[key] )
end

fact.merge!( 'service' => @service_fact )

puts JSON.pretty_generate(fact)

$stdout = STDOUT

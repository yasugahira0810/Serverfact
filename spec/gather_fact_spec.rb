require 'spec_helper'
require 'json'
require './spec/chkconfig.rb'

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
puts "******* #{ENV['TARGET_HOST']}/#{ENV['FACT_TIMING']} ********"
$stdout = File.open("spec/#{ENV['TARGET_HOST']}/#{ENV['FACT_TIMING']}.json", "w")

fact = {}

KEYS.each do |key|
  fact.merge!( key => host_inventory[key] )
end

fact.merge!( 'service' => @service_fact )

puts JSON.pretty_generate(fact)

$stdout = STDOUT

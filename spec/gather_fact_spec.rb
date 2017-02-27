require './spec/spec_helper.rb'
require 'specinfra'
require 'json'

puts "******** 1 *********"

#if host_inventory['platform'] == "redhat" && host_inventory['platform_version'].to_i < 7 then
#puts "#{host_inventory['platform_verion'].to_i}***"
#  require './spec/chkconfig.rb'
#elsif host_inventory['platform'] == "redhat" && host_inventory['platform_version'].to_i >= 7 then
#  require './spec/systemctl.rb'
#end
=begin
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
=end

KEYS = %w{
  user
}

ret = Specinfra::Runner.run_command('chkconfig --list').stdout

puts "******** 3 *********"

puts ret

#$stdout = File.open("nodes/#{ENV['TARGET_HOST']}/#{ENV['FACT_TIMING']}.json", "w")

fact = {}

KEYS.each do |key|
  fact.merge!( key => host_inventory[key] )
end

#fact.merge!( 'service' => @service_fact )

puts JSON.pretty_generate(fact)

#$stdout = STDOUT

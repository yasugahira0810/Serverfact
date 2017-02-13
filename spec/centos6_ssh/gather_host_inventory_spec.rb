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

HOSTNAME = ARGV[1].split("/")[1]
FILENAME = File.exist?("spec/#{HOSTNAME}/before.json") ? "after.json" : "before.json"
puts "OUTPUT: " + FILENAME
$stdout = File.open("spec/#{HOSTNAME}/#{FILENAME}", "w")

fact = {}

KEYS.each_with_index do |key, index|
  hash = { key => host_inventory[key] }
  fact.merge!(hash)
end

puts JSON.pretty_generate(fact)

$stdout = STDOUT

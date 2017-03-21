require 'spec_helper'
require 'json'
require 'gather_common'

keys = %w{
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

keys.each do |key|
  File.open("#{PATH}/#{key}.json", "w") do |f|
    f.puts JSON.pretty_generate( key => host_inventory[key] )
  end
end

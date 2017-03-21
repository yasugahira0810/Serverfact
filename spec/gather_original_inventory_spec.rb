require 'spec_helper'
require 'json'
require 'gather_common'

if host_inventory['platform'] == "redhat" && host_inventory['platform_version'].to_i < 7 then
  require './spec/chkconfig.rb'
elsif host_inventory['platform'] == "redhat" && host_inventory['platform_version'].to_i >= 7 then
  require './spec/systemctl.rb'
end

puts "platform #{host_inventory['platform']}, version #{host_inventory['platform_version']}"

keys = %w{
  service
}

keys.each do |key|
  File.open("#{PATH}/#{key}.json", "w") do |f|
    f.puts JSON.pretty_generate( key => @original_inventory[key] )
  end
end

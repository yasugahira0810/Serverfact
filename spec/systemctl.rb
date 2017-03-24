require 'spec_helper'

SYSTEMCTL_STDOUT = Specinfra::Runner::run_command('systemctl list-unit-files --type service').stdout
services = ""

@original_inventory = {'service' => {}}
@original_inventory['service'].update('enabled' => {})
@original_inventory['service'].update('running' => {})

# CREATE ENABLED HASH
SYSTEMCTL_STDOUT.each_line do |line|
  next line if /^UNIT\s*FILE\s*STATE\s*$/ =~ line
  next line if /^\s*$/ =~ line
  next line if /^*unit files listed.*$/ =~ line
  services << line
end

services.each_line do |service|
  unit_file, state = service.split
#  unit_file, state = service.split(" ", 2)
  @original_inventory['service']['enabled'].merge!(unit_file => state)
end

# CREATE RUNNING HASH
@original_inventory['service']['enabled'].keys.each do |service|
  running = Specinfra::Runner::run_command("systemctl status #{service}").exit_status.to_s
  @original_inventory['service']['running'].merge!(service => running)
end

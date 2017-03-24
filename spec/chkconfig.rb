require 'spec_helper'

@original_inventory = {'service' => {}}
@original_inventory['service'].update('enabled' => {})
@original_inventory['service'].update('running' => {})

# CREATE ENABLED HASH
ENABLED = Specinfra::Runner::run_command('chkconfig --list').stdout

ENABLED.each_line do |service|
  svc, runlvs = service.split(" ", 2)
  runlv = Hash[*runlvs.scan(/\d*\w+/)]
  @original_inventory['service']['enabled'].merge!(svc => runlv)
end

# CREATE RUNNING HASH
@original_inventory['service']['enabled'].keys.each do |service|
  running = Specinfra::Runner::run_command("service #{service} status").exit_status.to_s
  @original_inventory['service']['running'].merge!(service => running)
end

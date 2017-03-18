require 'spec_helper'

SERVICES = Specinfra::Runner::run_command('chkconfig --list').stdout

@original_inventory = {}
@original_inventory['service'] = {}

SERVICES.each_line do |service|
  svc, runlvs = service.split(" ", 2)
  runlv = Hash[*runlvs.scan(/\d*\w+/)]
  @original_inventory['service'].merge!(svc => runlv)
end

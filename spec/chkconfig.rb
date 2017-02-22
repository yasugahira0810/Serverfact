require 'spec_helper'

SERVICES = Specinfra::Runner::run_command('chkconfig --list').stdout

@service_fact = {}

SERVICES.each_line do |service|
  svc, runlvs = service.split(" ", 2)
  runlv = Hash[*runlvs.scan(/\d*\w+/)]
  @service_fact.merge!( svc => runlv)
end

puts @service_fact

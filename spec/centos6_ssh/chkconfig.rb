require 'spec_helper'

@SERVICES = Specinfra::Runner::run_command('chkconfig --list').stdout


@SERVICES.each_line do |service|
  svc, runlvs = service.split(" ", 2)
  runlv = Hash[*runlvs.scan(/\d+*\w+/)]
  puts "#{svc}: #{runlv}"
end


require './spec/spec_helper.rb'
require 'specinfra'
require 'serverspec'

puts "ababababa"

SERVICES = Specinfra::Runner::run_command('chkconfig --list').stdout
puts "ababababa"

@service_fact = {}
puts "ababababa"

SERVICES.each_line do |service|
  svc, runlvs = service.split(" ", 2)
  runlv = Hash[*runlvs.scan(/\d*\w+/)]
  @service_fact.merge!(svc => runlv)
end

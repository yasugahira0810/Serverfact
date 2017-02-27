require 'spec_helper'

SYSTEMCTL_STDOUT = Specinfra::Runner::run_command('systemctl list-unit-files --type service').stdout

SERVICES = ""

SYSTEMCTL_STDOUT.each_line do |line|
  next line if /^UNIT\s*FILE\s*STATE\s*$/ =~ line
  next line if /^\s*$/ =~ line
  next line if /^*unit files listed.*$/ =~ line
  SERVICES << line
end

@service_fact = {}

SERVICES.each_line do |service|
  unit_file, state = service.split
#  unit_file, state = service.split(" ", 2)
  @service_fact.merge!(unit_file => state)
end

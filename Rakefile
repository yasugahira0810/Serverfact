require 'rake'
require 'rspec/core/rake_task'

=begin
desc "rake TARGET_HOST='127.0.0.1' TIMING='before' gather"
RSpec::Core::RakeTask.new(:gather) do |t|
  directory ENV['TARGET_HOST']
  t.pattern = "spec/gather_fact_spec.rb"
end  

desc "diff"
=end

namespace :before do
  target = 'TARGET_HOST'
  ARGV.each do |arg|
    if arg =~/^before:/
      target = arg.dup
      target.slice!('before:')
    end
  end

  desc "Gather host info before reboot or migration"
  RSpec::Core::RakeTask.new(target.to_sym) do |t|
    ENV['NAMESPACE'] = 'before'
    ENV['TARGET_HOST'] = target
    t.pattern = "spec/gather_fact_spec.rb"
  end
end

namespace :after do
  target = 'TARGET_HOST'
  ARGV.each do |arg|
    if arg =~/^after:/
      target = arg.dup
      target.slice!('after:')
    end
  end

  desc "Gather host info after reboot or migration"
  RSpec::Core::RakeTask.new(target.to_sym) do |t|
    ENV['NAMESPACE'] = 'after'
    ENV['TARGET_HOST'] = target
    t.pattern = "spec/gather_fact_spec.rb"
  end
end

namespace :diff do
  target = 'TARGET_HOST'
  ARGV.each do |arg|
    if arg =~/^diff:/
      target = arg.dup
      target.slice!('diff:')
    end
  end

  desc "Test before.json using after.json's key. REVERSE flag will test them in reverse."
  RSpec::Core::RakeTask.new(target.to_sym) do |t|
    ENV['NAMESPACE'] = 'diff'
    ENV['TARGET_HOST'] = target
    t.pattern = "spec/diff_json_spec.rb"
  end
end

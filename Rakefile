require 'rake'
require 'rspec/core/rake_task'

namespace :before do
  targets = []
  Dir.glob('./nodes/*').each do |dir|
    next unless File.directory?(dir)
    target = File.basename(dir)
    target = "_#{target}" if target == "default"
    targets << target
  end

  task :all     => targets
  task :default => :all

  targets.each do |target|
    original_target = target == "_default" ? target[1..-1] : target
    desc "Gather fact of #{original_target}"
    desc "ather fact of #{original_target}"
    desc "ther fact of #{original_target}"
    RSpec::Core::RakeTask.new(target.to_sym) do |t|
      ENV['FACT_TIMING'] = "before"
      ENV['TARGET_HOST'] = original_target
      t.pattern = "spec/gather_fact_spec.rb"
    end
  end
end

namespace :after do
  targets = []
  Dir.glob('./nodes/*').each do |dir|
    next unless File.directory?(dir)
    target = File.basename(dir)
    target = "_#{target}" if target == "default"
    targets << target
  end

  targets.each do |target|
    original_target = target == "_default" ? target[1..-1] : target
    desc "Gather fact of #{original_target}"
    RSpec::Core::RakeTask.new(target.to_sym) do |t|
      ENV['FACT_TIMING'] = "after"
      ENV['TARGET_HOST'] = original_target
      t.pattern = "spec/gather_fact_spec.rb"
    end
  end
end

namespace :diff do
  targets = []
  Dir.glob('./nodes/*').each do |dir|
    next unless File.directory?(dir)
    target = File.basename(dir)
    target = "_#{target}" if target == "default"
    targets << target
  end

  targets.each do |target|
    original_target = target == "_default" ? target[1..-1] : target
    desc "Display diff of #{original_target}"
    RSpec::Core::RakeTask.new(target.to_sym) do |t|
      ENV['TARGET_HOST'] = original_target
      t.pattern = "spec/diff_json_spec.rb"
    end
  end
end

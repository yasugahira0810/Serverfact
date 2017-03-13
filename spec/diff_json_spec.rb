require 'spec_helper'
require 'json'

path = "nodes/#{ENV['TARGET_HOST']}"

before_fact = open("#{path}/before.json") do |io|
  JSON.load(io)
end

after_fact = open("#{path}/after.json") do |io|
  JSON.load(io)
end

after_fact.each do |key1, val1|
  if val1.is_a?(String) then
    describe command("echo #{key1}: #{val1}") do
      its(:stdout) { should match /#{before_fact[key1]}/ }
    end
  elsif !val1.nil?
    val1.each do |key2, val2|
      if val2.is_a?(String) then
        describe command("echo #{key2}: #{val2}") do
          its(:stdout) { should match /#{before_fact[key1][key2]}/ }
        end
      elsif !val2.nil?
        val2.each do |key3, val3|
          if val3.is_a?(String) then
            describe command("echo #{key3}: #{val3}") do
              its(:stdout) { should match /#{before_fact[key1][key2][key3]}/ }
            end
          elsif !val3.nil?
            val3.each do |key4, val4|
              if val4.is_a?(String) then
                describe command("echo #{key4}: #{val4}") do
                  its(:stdout) { should match /#{before_fact[key1][key2][key3][key4]}/ }
                end
              elsif !val4.nil?
                val4.each do |key5, val5|
                  if val5.is_a?(String) then
                    describe command("echo #{key5}: #{val5}") do
                      its(:stdout) { should match /#{before_fact[key1][key2][key3][key4][key5]}/ }
                    end
                  else
                    raise 'error'
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

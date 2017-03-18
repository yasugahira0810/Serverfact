require 'spec_helper'
require 'json'

PATH = "nodes/#{ENV['TARGET_HOST']}"

unless ENV['REVERSE'] == '1' then
  BEFORE_PATH = "#{PATH}/before"
  AFTER_PATH = "#{PATH}/after"
else
  BEFORE_PATH = "#{PATH}/after"
  AFTER_PATH = "#{PATH}/before"
end

before_jsons = []
after_jsons = []

Dir.foreach(BEFORE_PATH) do |f|
  next if f == '.' or f == '..'
  before_jsons.push(f.split(/.json$/))
end

Dir.foreach(AFTER_PATH) do |f|
  next if f == '.' or f == '..'
  after_jsons.push(f.split(/.json$/))
end



=begin
before_hash = open(BEFORE_JSON) do |io|
  JSON.load(io)
end

after_hash = open(AFTER_JSON) do |io|
  JSON.load(io)
end

unless (ENV['TARGET']).nil? then
  target_keys = ENV['TARGET'].split(',')
  temp_hash = {}
  target_keys.each do |t|
    unless before_hash.keys.include?(t) then
      raise "No such key #{t}"
    end
    temp_hash.merge!( t => before_hash[t])
  end
  before_hash = temp_hash
end

before_hash.each do |key1, val1|
  if val1.is_a?(String) then
    describe file(AFTER_JSON) do
      its(:content_as_json) { should include(key1 => val1) }
    end
  elsif !val1.nil?
    val1.each do |key2, val2|
      if val2.is_a?(String) then
        describe file(AFTER_JSON) do
          its(:content_as_json) { should include(key1 => include(key2 => val2)) }
        end
      elsif !val2.nil?
        val2.each do |key3, val3|
          if val3.is_a?(String) then
            describe file(AFTER_JSON) do
              its(:content_as_json) { should include(key1 => include(key2 => include(key3 => val3))) }
            end
          elsif !val3.nil?
            val3.each do |key4, val4|
              if val4.is_a?(String) then
                describe file(AFTER_JSON) do
                  its(:content_as_json) { should include(key1 => include(key2 => include(key3 => include(key4 => val4)))) }
                end
              elsif !val4.nil?
                val4.each do |key5, val5|
                  if val5.is_a?(String) then
                    describe file(AFTER_JSON) do
                      its(:content_as_json) { should include(key1 => include(key2 => include(key3 => include(key4 => include(key5 => val5))))) }
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
=end

require 'spec_helper'
require 'json'

PATH = "nodes/#{ENV['TARGET_HOST']}"

unless ENV['REVERSE'] == '1' then
  BEFORE_JSON = "#{PATH}/before.json"
  AFTER_JSON = "#{PATH}/after.json"
else
  BEFORE_JSON = "#{PATH}/after.json"
  AFTER_JSON = "#{PATH}/before.json"
end

BEFORE_HASH = open(BEFORE_JSON) do |io|
  JSON.load(io)
end

AFTER_HASH = open(AFTER_JSON) do |io|
  JSON.load(io)
end

BEFORE_HASH.each do |key1, val1|
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

require 'spec_helper'
require 'json'
require 'digest/md5'

PATH = "nodes/#{ENV['TARGET_HOST']}"

if !ENV['REVERSE'].nil? then
  BEFORE_PATH = "#{PATH}/before"
  AFTER_PATH = "#{PATH}/after"
else
  BEFORE_PATH = "#{PATH}/after"
  AFTER_PATH = "#{PATH}/before"
end

before_json_files = {}
after_json_files = {}

Dir.foreach(BEFORE_PATH) do |f|
  next if f == '.' or f == '..'
  md5 = Digest::MD5.file("#{BEFORE_PATH}/#{f}").to_s
  f.slice!(/.json$/)
  before_json_files.merge!( f => md5 )
end

Dir.foreach(AFTER_PATH) do |f|
  next if f == '.' or f == '..'
  md5 = Digest::MD5.file("#{AFTER_PATH}/#{f}").to_s
  f.slice!(/.json$/)
  after_json_files.merge!( f => md5 )
end

mismatch_jsons = []

before_json_files.each do |f, md5|
  describe file("#{AFTER_PATH}/#{f}.json") do
    its(:md5sum) { should eq md5 }
  end
  # [TODO] This comparison is redundant. There is still room for improvement. 
  mismatch_jsons.push(f) if before_json_files[f] != after_json_files[f]
end

if !ENV['ONLY'].nil? && before_json_files.keys.include?(ENV['ONLY']) then
  mismatch_jsons = [ ENV['ONLY'] ]
else
  puts "No such inventory"
  exit
end

before_hash = {}
after_hash = {}

mismatch_jsons.each do |f|
  File.open("#{BEFORE_PATH}/#{f}.json") do |io|
    before_hash = JSON.load(io)
  end
  File.open("#{AFTER_PATH}/#{f}.json") do |io|
    after_hash = JSON.load(io)
  end

  before_hash.each do |key1, val1|
    if val1.is_a?(String) then
      describe file("#{AFTER_PATH}/#{key1}.json") do
        its(:content_as_json) { should include(key1 => val1) }
      end
    elsif !val1.nil?
      val1.each do |key2, val2|
        if val2.is_a?(String) then
          describe file("#{AFTER_PATH}/#{key1}.json") do
            its(:content_as_json) { should include(key1 => include(key2 => val2)) }
          end
        elsif !val2.nil?
          val2.each do |key3, val3|
            if val3.is_a?(String) then
              describe file("#{AFTER_PATH}/#{key1}.json") do
                its(:content_as_json) { should include(key1 => include(key2 => include(key3 => val3))) }
              end
            elsif !val3.nil?
              val3.each do |key4, val4|
                if val4.is_a?(String) then
                  describe file("#{AFTER_PATH}/#{key1}.json") do
                    its(:content_as_json) { should include(key1 => include(key2 => include(key3 => include(key4 => val4)))) }
                  end
                elsif !val4.nil?
                  val4.each do |key5, val5|
                    if val5.is_a?(String) then
                      describe file("#{AFTER_PATH}/#{key1}.json") do
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
end

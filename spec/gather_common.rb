PATH = "nodes/#{ENV['TARGET_HOST']}/#{ENV['NAMESPACE']}"
FileUtils.mkdir_p(PATH) unless FileTest.exist?(PATH)

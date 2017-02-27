require 'serverspec'

if ENV['FACT_TIMING'] == "diff" then
  set :backend, :exec
else
  require 'net/ssh'
  
  set :backend, :ssh

puts "#{$0}, #{ARGV[0]}"
  
  if ENV['ASK_SUDO_PASSWORD']
    begin
      require 'highline/import'
    rescue LoadError
      fail "highline is not available. Try installing it."
    end
    set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
  else
    set :sudo_password, ENV['SUDO_PASSWORD']
  end
  
  host = ENV['TARGET_HOST']
  
  options = Net::SSH::Config.for(host)
  
  options[:user] ||= Etc.getlogin
  options[:password] ||= ENV['LOGIN_PASSWORD']
  
  set :host,        options[:host_name] || host
  set :ssh_options, options

end

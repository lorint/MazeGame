# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum, this matches the default thread size of Active Record.
#
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

# Specifies the `port` that Puma will listen on to receive requests, default is 3000.
# Note that this line (calling to port) also binds to tcp://0.0.0.0:????
#
# port        ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
#
rails_env = ENV.fetch("RAILS_ENV") { "development" }
environment rails_env

# For development, automatically bind with SSL on all private IPs
# If appropriate certificate files are missing, create them.
#
if rails_env == "development"
  begin
    # Filter to include only private IPv4 addresses (those not routable on the Internet)
    local_prefixes = ["10.", "127.", "172.16.", "172.17.", "172.18.", "172.19.",
      "172.20.", "172.21.", "172.22.", "172.23.", "172.24.", "172.25.", "172.26.",
      "172.27.", "172.28.", "172.29.", "172.30.", "172.31.", "169.254.", "192.168."]
    local_addresses = Socket.ip_address_list.select do |addr|
      addr.ipv4? && local_prefixes.inject(false) do |is_routable, prefix|
        is_routable || addr.ip_address.start_with?(prefix)
      end
    end
    local_addresses.each do |local_address|
      ip = local_address.ip_address
      snake_ip = ip.gsub(".", "_")
      bind "ssl://#{ip}:3000?key=#{ENV['HOME']}/.ssh/server#{snake_ip}.key&cert=#{ENV['HOME']}/.ssh/server#{snake_ip}.crt"
      # Make sure server##_##_##_##.crt and server##_##_##_##.key are present
      unless File.file?("#{ENV['HOME']}/.ssh/server#{snake_ip}.key") && File.file?("#{ENV['HOME']}/.ssh/server#{snake_ip}.crt")
        puts "Creating key and crt file for #{ip}"
        `openssl req -new -newkey rsa:2048 -sha1 -days 365 -nodes -x509 -subj "/C=UK/ST=Hertfordshire/L=Hoddesdon/O=SW/CN=#{ip}" -keyout ~/.ssh/server#{snake_ip}.key -out ~/.ssh/server#{snake_ip}.crt`
      end
    end
  rescue => e
    puts "Unable to automatically set up SSL binding(s) for local IP address(es)."
  end
end

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory. If you use this option
# you need to make sure to reconnect any threads in the `on_worker_boot`
# block.
#
# preload_app!

# The code in the `on_worker_boot` will be called if you are using
# clustered mode by specifying a number of `workers`. After each worker
# process is booted this block will be run, if you are using `preload_app!`
# option you will want to use this block to reconnect to any threads
# or connections that may have been created at application boot, Ruby
# cannot share connections between processes.
#
# on_worker_boot do
#   ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
# end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

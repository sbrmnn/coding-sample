class Rack::Attack
  
  ### Configure Cache ###

  # If you don't want to use Rails.cache (Rack::Attack's default), then
  # configure it here.
  #
  # Note: The store is only used for throttling (not blacklisting and
  # whitelisting). It must implement .increment and .write like
  # ActiveSupport::Cache::Store

  # Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new 

  ### Throttle Spammy Clients ###

  # If any single client IP is making tons of requests, then they're
  # probably malicious or a poorly-configured scraper. Either way, they
  # don't deserve to hog all of the app server's CPU. Cut them off!
  #
  # Note: If you're serving assets through rack, those requests may be
  # counted by rack-attack and this throttle may be activated too
  # quickly. If so, enable the condition to exclude them from tracking.

  # Throttle all requests by IP (60rpm)
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
  throttle('req/ip', :limit => 500, :period => 5.minutes) do |req|
    req.ip 
  end

  ### Prevent Brute-Force Login Attacks ###

  # The most common brute-force login attack is a brute-force password
  # attack where an attacker simply tries a large number of emails and
  # passwords to see if any credentials match.
  #
  # Another common method of attack is to use a swarm of computers with
  # different IPs to try brute-forcing a password for a specific account.

  # Throttle POST requests to /login by IP address
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:logins/ip:#{req.ip}"


# Allows 20 requests in 8  seconds
# 40 requests in 64 seconds
# ...
# 100 requests in 0.38 days (~250 requests/day)
(1..5).each do |level|
  throttle('logins/ip/#{level}', :limit => (20 * level), :period => (8 ** level).seconds) do |req|
    if (req.path == '/login' || req.path == '/login.json') && req.post?
      req.ip
    end
  end
end

(1..5).each do |level|
  throttle('monotto_users/logins/ip/#{level}', :limit => (20 * level), :period => (8 ** level).seconds) do |req|
    if (req.path == '/monotto_users/login' || req.path == '/monotto_users/login.json') && req.post?
      req.ip
    end
  end
end


  # Throttle POST requests to /login by email param
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:logins/email:#{req.email}"
  #
  # Note: This creates a problem where a malicious user could intentionally
  # throttle logins for another user and force their login requests to be
  # denied, but that's not very common and shouldn't happen to you. (Knock
  # on wood!)

(1..5).each do |level|
  throttle('monotto_user/logins/email/#{level}', :limit => (20 * level), :period => (8 ** level).seconds) do |req|
    if (req.path == '/monotto_users/login' || req.path == '/monotto_users/login.json') && req.post?
      req.params['email']
    end
  end
end

(1..5).each do |level|
  throttle('logins/email/#{level}', :limit => (20 * level), :period => (8 ** level).seconds) do |req|
    if (req.path == '/login' || req.path == '/login.json') && req.post?
      req.params['email']
    end
  end
end


  ### Custom Throttle Response ###

  # By default, Rack::Attack returns an HTTP 429 for throttled responses,
  # which is just fine.
  #
  # If you want to return 503 so that the attacker might be fooled into
  # believing that they've successfully broken your app (or you just want to
  # customize the response), then uncomment these lines.
  # self.throttled_response = lambda do |env|
  #  [ 503,  # status
  #    {},   # headers
  #    ['']] # body
  # end
end

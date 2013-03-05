require 'OAuth'
require 'yaml'

auth = YAML.load_file("download-auth.yml")
consumer = OAuth::Consumer.new(auth["consumer_key"].to_s, auth["consumer_secret"].to_s,
  { :site => "http://api.twitter.com",
    :scheme => :header
  })
access_token = OAuth::AccessToken.from_hash(consumer,
  { :oauth_token => auth["oauth_token"].to_s,
    :oauth_token_secret => auth["oauth_token_secret"].to_s
  })

twers = []
File.open("twitternames.txt", "r").each_line do |line|
  unless line.start_with?("#") or line.strip == "" then
    twers.push(line.strip)
  end
end

twers.each do |username|
  filename = "followers-#{username}.json"
  next if File.exists?(filename)
  response = nil
  loop do
    response = access_token.request(:get, "https://api.twitter.com/1.1/followers/ids.json?cursor=-1&screen_name=" + username + "&count=5000")
    puts "#{username}: #{response.code} (#{response.message})"
    break if response.code == "200"
    if response.code == "429" then
      print "sleeping for 5 minutes due to rate limit"
      for i in (1..5) do
        sleep 60
        print "."
      end
      puts
    else
      puts response.body
      exit(response.code.to_i)
    end
  end
  File.open(filename, "w") { |file| file.write(response.body) }
end

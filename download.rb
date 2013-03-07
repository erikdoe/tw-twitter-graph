require 'OAuth'
require 'yaml'
require 'json'

load 'shared.rb'


def create_token()
  auth = YAML.load_file("download-auth.yml")
  consumer = OAuth::Consumer.new(auth["consumer_key"].to_s, auth["consumer_secret"].to_s,
    { :site => "http://api.twitter.com",
      :scheme => :header
    })
  access_token = OAuth::AccessToken.from_hash(consumer,
    { :oauth_token => auth["oauth_token"].to_s,
      :oauth_token_secret => auth["oauth_token_secret"].to_s
    })
  access_token
end


def download_followers(access_token, username, cursor = "-1")
  filename = response_filename(username, cursor)
  return if File.exists?(filename) # TODO: handle the case where only the first file(s) of a set exist
  response = nil
  loop do
    response = access_token.request(:get, "https://api.twitter.com/1.1/followers/ids.json?cursor=#{cursor}&screen_name=#{username}&count=5000")
    puts "#{filename}: #{response.code} (#{response.message})"
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
  next_cursor = JSON.parse(response.body)["next_cursor_str"]
  if next_cursor != "0" then
    download_followers(access_token, username, next_cursor)
  end
end


access_token = create_token()
read_names().each do |username|
  download_followers(access_token, username) 
end

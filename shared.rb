
def read_names()
  File.open("data/twitternames.txt", "r")
    .readlines
    .reject { |line| line.start_with?("#") or line.strip == "" } 
    .map { |line| line.strip }
end

def create_map(names)
  names.inject({}) do |result, name| 
    result[name] = { :id => result.length, :fcount => 0 }
    result
  end
end

def response_filename(username, cursor = "-1")
  suffix = (cursor == "-1") ? "" : "-#{cursor}"
  "data/followers-#{username}#{suffix}.json"
end

def add_follower_file(username, filename, twers, followers)
  return unless File.exists?(filename)
  response = JSON.parse(File.read(filename))
  twers[username][:fcount] += response["ids"].length
  response["ids"].each do |followerid|
    followers[followerid] ||= []
    followers[followerid].push(twers[username][:id])
  end
  next_cursor = response["next_cursor_str"]
  if next_cursor != "0" then
    add_follower_file(username, response_filename(username, next_cursor), twers, followers)
  end
end

def read_followers(twers)
  followers = {}
  twers.each_key do |username|
    add_follower_file(username, response_filename(username), twers, followers)
  end
  followers
end

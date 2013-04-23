
def read_names()
  File.open("data/input.csv", "r")
    .readlines
    .reject { |line| line.start_with?("#") or line.strip == "" } 
    .map { |line| line.split(/,/)[2].strip.gsub(/@/, "") }
end

def create_map(names)
  results = {}
  names.each_with_index do |name, idx| 
    response = JSON.parse(File.read(user_filename(name)))[0]
    results[name] = { 
      :idx => idx,
      :id => response["id"],
      :name => response["name"],
      :fcount => response["followers_count"], 
      :tcount => response["statuses_count"] }
  end
  results
end

def user_filename(username)
  "data/user-#{username}.json"
end

def follower_filename(username, cursor = "-1")
  suffix = (cursor == "-1") ? "" : "-#{cursor}"
  "data/followers-#{username}#{suffix}.json"
end

def add_follower_file(username, filename, twers, followers, key)
  return unless File.exists?(filename)
  response = JSON.parse(File.read(filename))
  response["ids"].each do |followerid|
    followers[followerid] ||= []
    followers[followerid].push(twers[username][key])
  end
  next_cursor = response["next_cursor_str"]
  if next_cursor != "0" then
    add_follower_file(username, follower_filename(username, next_cursor), twers, followers, key)
  end
end

def read_followers(twers, key=:idx)
  followers = {}
  twers.each_key do |username|
    add_follower_file(username, follower_filename(username), twers, followers, key)
  end
  followers
end

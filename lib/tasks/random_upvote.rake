task :random_upvote => :environment do
  wods = Wod.all.within_past_24h
  wod = wods.sample
  dummy = User.new
  dummy.admin = true
  wod.upvote(dummy)
  puts "upvoted wod #{wod.id}, wod now has #{wod.points} points -- #{Time.now}"
end

task :update_gym_wods => :environment do
  puts "updating gym wods..."
  puts Time.now
  Gym.all.approved.each do |gym|
    puts "updating " + gym.name + "..."
    status = gym.check_for_new_wod
    if status[:error]
      puts "\e[31m***error***\e[0m"
    else
      puts "\e[32m#{status.keys.first.to_s}\e[0m"
    end
  end
  puts "----"
  puts "\e[32mDONE!\e[0m"
end

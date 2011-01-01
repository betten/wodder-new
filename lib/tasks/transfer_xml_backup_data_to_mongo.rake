task :transfer_xml_backup_data_to_mongo => :environment do
  puts "starting transfer..."
  puts "switching to tmp/backup..."
  Dir.chdir(Dir.pwd.concat("/tmp/backup"))

  puts "checking files..."
  %w(donations.xml users.xml gym_datas.xml wods.xml).each { |file| error("missing " + file) unless File::exists?(file) }

  puts "creating hpricot objects..."
  donations = getHpricotFromFile('donations.xml')
  users = getHpricotFromFile('users.xml')
  gym_datas = getHpricotFromFile('gym_datas.xml')
  wods = getHpricotFromFile('wods.xml')

  puts "creating users..."
  users.search("user").each do |user_element|
    user = User.new
    user.email = user_element.at("email").to_plain_text
    puts "creating #{user.email}..."
    username = user.email.split("@").first.gsub(/\W/,"")
    user.username = username
    user.password = username
    user.password_confirmation = username
    user.paid = true
    wods.search("user-id[text()=#{user_element.at("id").inner_text}]/..").each do |wod_element|
      wod = Wod.new
      gym = gym_datas.search("id[text()=#{wod_element.at("gym-id").to_plain_text}]/..")
      wod.workout = "<div><a href='#{gym.at("href").to_plain_text}'>#{gym.at("title").to_plain_text}</a></div>".concat(wod_element.at("workout").to_plain_text)
      wod.save
      user.saved_wods << wod
    end
    if user.save
      success("#{user.email} saved successfully with #{user.saved_wods.count} wods!")
    else
      error("#{user.email} save failed")
    end   
  end
  
  success("DONE! Data transferred successfully!")
end

def error(message)
  abort "\e[31mtransfer aborted! #{message}\e[0m"
end

def success(message)
  puts "\e[32m#{message}\e[0m"
end

def getHpricotFromFile(filename)
  File.open(filename, 'r') { |file| Hpricot(file) }
end

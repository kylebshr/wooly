task default: %w[carthage generate]

task :set_version => [:set_marketing_number, :set_build_number] do
end

task :generate do
    puts 'Generating project...'
    `xcodegen`
end

task :carthage do
    puts 'Bootstrapping dependencies...'
    `carthage bootstrap --platform iOS --cache-builds`
end

task :'carthage_update' do
    puts 'Updating dependencies...'
    `carthage update --platform iOS --cache-builds`
end

task :set_marketing_number do
    now = Time.new
    major = now.strftime("%V")
    month = Time.new(now.year, now.month)
    minor = (now - month).to_i
    build_number = "1.#{major}.#{minor}"
    puts "Updating marketing number to #{build_number}..."
    `agvtool new-marketing-version #{build_number}`
end

task :set_build_number do
    now = Time.new
    today = Time.new(now.year, now.month, now.day, now.hour)
    sec_elapsed = (now - today).to_i
    build_number = "#{now.year}.#{now.month}.#{now.day}.#{now.hour}.#{sec_elapsed}"
    puts "Updating build number to #{build_number}..."
    `agvtool new-version #{build_number}`
end

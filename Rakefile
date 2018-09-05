task default: %w[carthage generate]

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

task :set_marketing_number, :marketing_number do |t, args|
    marketing_number = args[:marketing_number]
    puts "Updating marketing number to #{marketing_number}..."
    `agvtool new-marketing-version #{marketing_number}`
end

task :set_build_number, :build_number do |t, args|
    build_number = args[:build_number]
    puts "Updating build number to #{build_number}..."
    `agvtool new-version #{build_number}`
end

task default: %w[carthage generate]

task :generate do
    puts 'Generating project...'
    `xcodegen`
end

task :carthage do
    puts 'Bootstrapping dependencies...'
    `carthage bootstrap --platform iOS --cache-builds`
end

task :'carthage-update' do
    puts 'Updating dependencies...'
    `carthage update --platform iOS --cache-builds`
end

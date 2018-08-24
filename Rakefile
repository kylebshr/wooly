task default: %w[carthage generate]

task :generate do
    puts 'Generating project...'
    `xcodegen`
end

task :carthage do
    puts 'Updating dependencies...'
    `carthage bootstrap --platform iOS --cache-builds`
end

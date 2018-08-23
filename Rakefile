task default: %w[carthage generate]

task :generate do
    `xcodegen`
end

task :carthage do
    `carthage bootstrap --platform iOS --cache-builds`
end

Pod::Spec.new do |s|
    s.name = "BlackBox"
    s.version = "0.5.7"
    s.summary = "Logging library for iOS"

    s.source = { :git => "git@github.com:dodopizza/BlackBox-ios.git", :tag => s.version }
    s.homepage = "https://github.com/dodopizza/BlackBox-ios"

    s.license = 'Apache License, Version 2.0'
    s.author = { "Aleksey Berezka" => "a.berezka@dodopizza.com" }

    s.ios.deployment_target = "10.0"
    s.swift_version = '5.1'

    s.source_files = 'Sources/**/*.swift'

    s.frameworks = 'Foundation'
end

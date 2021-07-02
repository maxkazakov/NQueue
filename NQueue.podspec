Pod::Spec.new do |spec|
    spec.name         = "NQueue"
    spec.version      = "1.1.0"
    spec.summary      = "Queue wrapper of DispatchQueue"

    spec.source       = { :git => "git@github.com:NikSativa/NQueue.git" }
    spec.homepage     = "https://github.com/NikSativa/NQueue"

    spec.license          = 'MIT'
    spec.author           = { "Nikita Konopelko" => "nik.sativa@gmail.com" }
    spec.social_media_url = "https://www.facebook.com/Nik.Sativa"

    spec.ios.deployment_target = "10.0"
    spec.swift_version = '5.0'

    spec.frameworks = 'Foundation', 'UIKit'

    spec.source_files = 'Source/**/*.{swift,storyboard,xib}'
end
